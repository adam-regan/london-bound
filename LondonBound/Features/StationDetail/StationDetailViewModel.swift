//
//  StationDetailViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import Foundation
internal import Combine

@MainActor
final class StationDetailViewModel: ObservableObject {
    @Published private(set) var arrivals: Loadable<[Arrival]> = .idle
    @Published private(set) var isSaved = false

    private let station: StationDetail
    private let apiService: TFLAPIServiceProtocol
    private let savedStations: SavedStationsRepositoryProtocol
    private let arrivalsCache: ArrivalsCache

    init(
        station: StationDetail,
        tflAPIService: TFLAPIServiceProtocol,
        savedStationsRepository: SavedStationsRepositoryProtocol,
        arrivalsCache: ArrivalsCache = ArrivalsCache()
    ) {
        self.station = station
        apiService = tflAPIService
        savedStations = savedStationsRepository
        self.arrivalsCache = arrivalsCache

        savedStations.stations
            .receive(on: DispatchQueue.main)
            .map { stations in stations.contains { $0.id == station.id } }
            .assign(to: &$isSaved)
    }

    func fetchArrivals() {
        if let cached = arrivalsCache.arrivals(for: station.id) {
            arrivals = .loaded(cached)      // show last-known rows immediately
        } else if case .loaded = arrivals {
            // already populated; refresh silently
        } else {
            arrivals = .loading
        }

        Task {
            do {
                let fresh = try await apiService.fetchArrivals(stationId: station.id)
                arrivalsCache.store(fresh, for: station.id)
                arrivals = .loaded(fresh)
            } catch {
                if case .loaded = arrivals { return }   // keep stale rows on error
                arrivals = .error(error)
            }
        }
    }

    func toggleSaved() {
        Task {
            if isSaved {
                await savedStations.remove(id: station.id)
            } else {
                await savedStations.save(SavedStation(station))
            }
        }
    }
}
