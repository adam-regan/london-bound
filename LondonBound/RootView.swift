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
        VStack {
            Group {
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
            .foregroundStyle(Color.theme.textPrimary)

            CustomTabBarView(selectedTab: $selectedTab)
        }
        .background(Color.theme.background)
    }
}

#Preview {
    RootView()
}
