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
    @StateObject private var nearbyCoordinator = MainCoordinator()
    @ObservedObject var statusViewModel: StatusViewModel
    @ObservedObject var arrivalsViewModel: ArrivalsViewModel
    @ObservedObject var nearbyViewModel: NearbyViewModel

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
    let api = TFLAPIServiceStub()
    RootView(
        statusViewModel: StatusViewModel(tflAPIService: api),
        arrivalsViewModel: ArrivalsViewModel(tflAPIService: api),
        nearbyViewModel: NearbyViewModel(tflAPIService: api, locationProvider: LocationProviderStub())
    )
}
