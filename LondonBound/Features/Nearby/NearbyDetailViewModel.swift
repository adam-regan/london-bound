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

    private let apiService: TFLAPIServiceProtocol

    init(tflAPIService: TFLAPIServiceProtocol) {
        apiService = tflAPIService
    }

    func fetchArrivals(stationId: String) {
        arrivals = .loading
        Task {
            do {
                arrivals = try .loaded(await apiService.fetchArrivals(stationId: stationId))
            } catch {
                arrivals = .error(error)
            }
        }
    }
}
