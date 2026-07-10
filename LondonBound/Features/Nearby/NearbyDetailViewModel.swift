//
//  NearbyDetailViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import Foundation
internal import Combine

@MainActor
final class NearbyDetailViewModel: ObservableObject {
    @Published private(set) var arrivals: Loadable<[Arrival]> = .idle
    @Published private(set) var isSaved = false

    private let station: NearbyStation
    private let apiService: TFLAPIServiceProtocol
    private let savedStations: SavedStationsRepositoryProtocol

    init(station: NearbyStation, tflAPIService: TFLAPIServiceProtocol, savedStationsRepository: SavedStationsRepositoryProtocol) {
        self.station = station
        apiService = tflAPIService
        savedStations = savedStationsRepository

        savedStations.stations
            .receive(on: DispatchQueue.main)
            .map { stations in stations.contains { $0.id == station.id } }
            .assign(to: &$isSaved)
    }

    func fetchArrivals() {
        arrivals = .loading
        Task {
            do {
                arrivals = try .loaded(await apiService.fetchArrivals(stationId: station.id))
            } catch {
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
