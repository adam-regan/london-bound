//
//  AppDependencies.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import Foundation

struct AppDependencies {
    let tflAPIService: TFLAPIServiceProtocol
    let locationProvider: LocationProviderProtocol
    let savedStationsRepository: SavedStationsRepositoryProtocol
    let arrivalsCache: ArrivalsCache

    init(
        tflAPIService: TFLAPIServiceProtocol,
        locationProvider: LocationProviderProtocol,
        savedStationsRepository: SavedStationsRepositoryProtocol,
        arrivalsCache: ArrivalsCache = ArrivalsCache()
    ) {
        self.tflAPIService = tflAPIService
        self.locationProvider = locationProvider
        self.savedStationsRepository = savedStationsRepository
        self.arrivalsCache = arrivalsCache
    }
}

#if DEBUG
extension AppDependencies {
    static let preview = AppDependencies(
        tflAPIService: TFLAPIServiceStub(),
        locationProvider: LocationProviderStub(),
        savedStationsRepository: SavedStationsRepositoryStub()
    )
}
#endif
