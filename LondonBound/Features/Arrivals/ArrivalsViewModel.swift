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
    @Published private(set) var isSelectedStationSaved = false

    @Published var searchQuery: String = ""

    private lazy var poller = Poller(interval: 30) { [weak self] in
        if let station = self?.selectedStation {
            self?.fetchArrivals(stationId: station.id)
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let apiService: TFLAPIServiceProtocol
    private let savedStations: SavedStationsRepositoryProtocol

    init(tflAPIService: TFLAPIServiceProtocol, savedStationsRepository: SavedStationsRepositoryProtocol) {
        apiService = tflAPIService
        savedStations = savedStationsRepository
        observeSearchText()
        observeSavedState()
    }

    func toggleSaved() {
        guard let station = selectedStation else { return }
        Task {
            if isSelectedStationSaved {
                await savedStations.remove(id: station.id)
            } else {
                await savedStations.save(SavedStation(station))
            }
        }
    }

    func selectStation(_ station: Station) {
        searchQuery = ""
        searchResults = .idle
        arrivals = .idle
        selectedStation = station
        poller.start()
    }

    func startPolling() {
        poller.start()
    }

    func retryArrivals() {
        arrivals = .idle
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

    private func observeSavedState() {
        Publishers.CombineLatest($selectedStation, savedStations.stations)
            .map { station, saved in
                guard let station else { return false }
                return saved.contains { $0.id == station.id }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isSelectedStationSaved)
    }

    private func observeSearchText() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
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
