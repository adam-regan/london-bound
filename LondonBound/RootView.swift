//
//  ContentView.swift
//  LondonBound
//
//  Created by Adam Regan on 29/04/2026.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .status

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                switch selectedTab {
                    case .status:
                        StatusView()
                    case .arrivals:
                        Text("arrivals")
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
    }
}

#Preview {
    RootView()
}
