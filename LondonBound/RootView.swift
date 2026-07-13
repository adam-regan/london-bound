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

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
        .background(Color.theme.background)
        .ignoresSafeArea(.keyboard)
    }

    private var iPhoneLayout: some View {
        VStack(spacing: 0) {
            destination(for: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBarView(selectedTab: $selectedTab)
        }
    }

    private var iPadLayout: some View {
        HStack(spacing: 0) {
            CustomSideBarView(selectedTab: $selectedTab)

            destination(for: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder
    private func destination(for tab: Tab) -> some View {
        switch tab {
        case .status:
            NavigationStack(path: $statusCoordinator.path) {
                StatusView()
                    .environmentObject(statusViewModel)
                    .environmentObject(statusCoordinator)
                    .navigationDestination(for: Page.self) { page in
                        statusCoordinator.build(page: page)
                    }
            }
        case .arrivals:
            ArrivalsView(viewModel: arrivalsViewModel)
        case .nearby:
            NavigationStack(path: $nearbyCoordinator.path) {
                NearbyView(viewModel: nearbyViewModel, coordinator: nearbyCoordinator)
                    .navigationDestination(for: Page.self) { page in
                        nearbyCoordinator.build(page: page)
                    }
            }
        case .saved:
            SavedView(viewModel: savedViewModel)
        }
    }
}

#Preview {
    RootView(dependencies: .preview)
}
