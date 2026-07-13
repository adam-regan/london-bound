//
//  NearbyViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 06/07/2026.
//

internal import Combine

@MainActor
final class NearbyViewModel: ObservableObject {
    @Published private(set) var nearby: Loadable<[NearbyStation]> = .idle

    private let apiService: TFLAPIServiceProtocol
    private let locationProvider: LocationProviderProtocol

    init(tflAPIService: TFLAPIServiceProtocol, locationProvider: LocationProviderProtocol) {
        apiService = tflAPIService
        self.locationProvider = locationProvider
    }

    func fetchNearby() {
        if nearby == .idle {
            nearby = .loading
        }
        Task {
            do {
                let coords = try await locationProvider.currentLocation()
                let stations = try await apiService.fetchNearby(coords: coords)
                nearby = .loaded(stations)
            } catch {
                nearby = .error(error)
            }
        }
    }
}
