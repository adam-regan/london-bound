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
    @StateObject private var savedViewModel: SavedViewModel

    init(dependencies: AppDependencies) {
        _nearbyCoordinator = StateObject(wrappedValue: MainCoordinator(dependencies: dependencies))
        _statusViewModel = StateObject(wrappedValue: StatusViewModel(tflAPIService: dependencies.tflAPIService))
        _arrivalsViewModel = StateObject(wrappedValue: ArrivalsViewModel(tflAPIService: dependencies.tflAPIService, savedStationsRepository: dependencies.savedStationsRepository))
        _nearbyViewModel = StateObject(wrappedValue: NearbyViewModel(tflAPIService: dependencies.tflAPIService, locationProvider: dependencies.locationProvider))
        _savedViewModel = StateObject(wrappedValue: SavedViewModel(repository: dependencies.savedStationsRepository))
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
                        SavedView(viewModel: savedViewModel)
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
    RootView(dependencies: .preview)
}
