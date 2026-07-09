//
//  ContentView.swift
//  LondonBound
//
//  Created by Adam Regan on 29/04/2026.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .status
    @StateObject private var statusCoordinator = MainCoordinator()
    @StateObject private var nearbyCoordinator: MainCoordinator
    @StateObject private var statusViewModel: StatusViewModel
    @StateObject private var arrivalsViewModel: ArrivalsViewModel
    @StateObject private var nearbyViewModel: NearbyViewModel

    init(tflAPIService: TFLAPIServiceProtocol, locationProvider: LocationProviderProtocol) {
        _nearbyCoordinator = StateObject(wrappedValue: MainCoordinator(tflAPIService: tflAPIService))
        _statusViewModel = StateObject(wrappedValue: StatusViewModel(tflAPIService: tflAPIService))
        _arrivalsViewModel = StateObject(wrappedValue: ArrivalsViewModel(tflAPIService: tflAPIService))
        _nearbyViewModel = StateObject(wrappedValue: NearbyViewModel(tflAPIService: tflAPIService, locationProvider: locationProvider))
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                switch selectedTab {
                    case .status:
                        StatusView()
                            .environmentObject(statusViewModel)
                            .environmentObject(statusCoordinator)
                    case .arrivals:
                        ArrivalsView(viewModel: arrivalsViewModel)
                    case .nearby:
                        NearbyView(viewModel: nearbyViewModel, coordinator: nearbyCoordinator)
                    case .saved:
                        Text("saved")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBarView(selectedTab: $selectedTab)
        }
        .background(Color.theme.background)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    RootView(
        tflAPIService: TFLAPIServiceStub(),
        locationProvider: LocationProviderStub()
    )
}
