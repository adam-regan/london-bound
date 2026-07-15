//
//  SavedAddViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 15/07/2026.
//

internal import Combine
import Foundation

@MainActor
final class SavedAddViewModel: ObservableObject {
    @Published private(set) var searchResults: Loadable<[Station]> = .idle
    @Published private(set) var savedIDs: Set<String> = []
    @Published var searchQuery: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let apiService: TFLAPIServiceProtocol
    private let savedStations: SavedStationsRepositoryProtocol
    private let searchDebounce: RunLoop.SchedulerTimeType.Stride

    init(
        tflAPIService: TFLAPIServiceProtocol,
        savedStationsRepository: SavedStationsRepositoryProtocol,
        searchDebounce: RunLoop.SchedulerTimeType.Stride = .milliseconds(300)
    ) {
        apiService = tflAPIService
        savedStations = savedStationsRepository
        self.searchDebounce = searchDebounce
        observeSearchText()
        savedStations.stations
            .map { Set($0.map(\.id)) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$savedIDs)
    }

    func add(_ station: Station) {
        Task { await savedStations.save(SavedStation(station)) }
    }

    func reset() {
        searchQuery = ""
        searchResults = .idle
    }

    private func observeSearchText() {
        $searchQuery
            .debounce(for: searchDebounce, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if query.count > 2 {
                    self?.search(query)
                } else {
                    self?.searchResults = .idle
                }
            }
            .store(in: &cancellables)
    }

    private func search(_ query: String) {
        Task {
            do {
                if searchResults == .idle {
                    searchResults = .loading
                }
                let response = try await apiService.fetchStations(name: query)
                searchResults = .loaded(response.matches)
            } catch {
                searchResults = .idle
            }
        }
    }
}
