//
//  ArrivalsViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 29/06/2026.
//

internal import Combine
import Foundation

@MainActor
final class ArrivalsViewModel: ObservableObject {
    @Published private(set) var selectedStation: Station?
    @Published private(set) var arrivals: [Arrival] = []
    @Published private(set) var searchResults: Loadable<[Station]> = .idle

    @Published var searchQuery: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let apiService: TFLAPIServiceProtocol

    init(tflAPIService: TFLAPIServiceProtocol) {
        apiService = tflAPIService
        observeSearchText()
    }

    func selectStation(_ station: Station) {
        searchQuery = ""
        searchResults = .idle
        selectedStation = station
        Task {
            do {
                arrivals = try await apiService.fetchArrivals(stationId: station.id)
            } catch {
                print("Failed to fetch arrivals: \(error)")
            }
        }
    }

    private func observeSearchText() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if query.count > 1 {
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
