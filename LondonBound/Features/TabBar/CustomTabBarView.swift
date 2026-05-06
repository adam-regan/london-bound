//
//  CustomTabView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 17/02/2026.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack {
            VStack(spacing: Spacing.md) {
                Divider()
                    .overlay(Color.theme.secondary)
                HStack(alignment: .center) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        CustomTabView(
                            selectedTab: $selectedTab,
                            tab: tab
                        )
                    }
                }
            }
            .frame(
                maxWidth: .infinity
            )
            .background(Color.theme.background)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

#Preview {
    @Previewable @State var selectedTab: Tab = .status
    VStack {
        CustomTabBarView(selectedTab: $selectedTab)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    .background(Color.theme.surface)
}
