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
    var body: some Scene {
        WindowGroup {
            RootView(
                tflAPIService: TFLAPIService(),
                locationProvider: LocationProvider()
            )
        }
    }
}
