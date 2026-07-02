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
    @StateObject private var statusViewModel: StatusViewModel
    @StateObject private var arrivalsViewModel: ArrivalsViewModel

    init(api: TFLAPIServiceProtocol = TFLAPIService()) {
        _statusViewModel = StateObject(wrappedValue: StatusViewModel(tflAPIService: api))
        _arrivalsViewModel = StateObject(wrappedValue: ArrivalsViewModel(tflAPIService: api))
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
                        Text("nearby")
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
    RootView(api: TFLAPIServiceStub())
}
