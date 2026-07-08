//
//  LondonBoundApp.swift
//  LondonBound
//
//  Created by Adam Regan on 29/04/2026.
//

import SwiftData
import SwiftUI

@main
struct LondonBoundApp: App {
    @StateObject private var statusViewModel: StatusViewModel
    @StateObject private var arrivalsViewModel: ArrivalsViewModel
    @StateObject private var nearbyViewModel: NearbyViewModel

    init() {
        let api = TFLAPIService()
        let locationProvider = LocationProvider()
        _statusViewModel = StateObject(wrappedValue: StatusViewModel(tflAPIService: api))
        _arrivalsViewModel = StateObject(wrappedValue: ArrivalsViewModel(tflAPIService: api))
        _nearbyViewModel = StateObject(wrappedValue: NearbyViewModel(tflAPIService: api, locationProvider: locationProvider))
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                statusViewModel: statusViewModel,
                arrivalsViewModel: arrivalsViewModel,
                nearbyViewModel: nearbyViewModel
            )
        }
    }
}
