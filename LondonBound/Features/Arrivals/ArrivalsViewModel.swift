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
    @Published private(set) var arrivals: Loadable<[Arrival]> = .idle
    @Published private(set) var searchResults: Loadable<[Station]> = .idle
    @Published private(set) var timeUpdated: String?

    @Published var searchQuery: String = ""

    private lazy var poller = Poller(interval: 30) { [weak self] in
        if let station = self?.selectedStation {
            self?.fetchArrivals(stationId: station.id)
        }
    }

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
        poller.start()
    }

    func startPolling() {
        poller.start()
    }

    func stopPolling() {
        poller.stop()
    }

    private func fetchArrivals(stationId: String) {
        if arrivals == .idle {
            arrivals = .loading
        }

        Task {
            do {
                arrivals = try .loaded(await apiService.fetchArrivals(stationId: stationId))
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "H:mm"
                timeUpdated = formatter.string(from: now)
            } catch {
                arrivals = .error(error)
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
