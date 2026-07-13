//
//  CustomSideBarView.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import SwiftUI

struct CustomSideBarView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            ForEach(Tab.allCases, id: \.self) { tab in
                SideBarItemView(selectedTab: $selectedTab, tab: tab)
            }
            Spacer()
        }
        .padding(Spacing.sm)
        .frame(width: 220, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color.theme.background)
        .overlay(alignment: .trailing) {
            Divider()
                .overlay(Color.theme.secondary)
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: Tab = .status
    HStack(spacing: 0) {
        CustomSideBarView(selectedTab: $selectedTab)
        Color.theme.background
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.theme.background)
}
