//
//  LondonBoundApp.swift
//  LondonBound
//
//  Created by Adam Regan on 29/04/2026.
//

import SwiftUI

@main
struct LondonBoundApp: App {
    private let dependencies = AppDependencies(
        tflAPIService: TFLAPIService(),
        locationProvider: LocationProvider(),
        savedStationsRepository: CoreDataSavedStationsRepository()
    )

    var body: some Scene {
        WindowGroup {
            RootContainerView(dependencies: dependencies)
        }
    }
}
