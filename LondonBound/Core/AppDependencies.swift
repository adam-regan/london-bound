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
