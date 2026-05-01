//
//  CustomTab.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    var tab: Tab

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack {
                Image(systemName: tab.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(tab.label)
                    .font(.footnote)
            }
        }

        .buttonStyle(.plain)
        .padding(.horizontal, Spacing.lg)
        .foregroundStyle(
            selectedTab == tab.self ? Color.theme.primary : Color.theme.secondary
        )
    }
}

#Preview("Selected") {
    @Previewable @State var selectedTab: Tab = .status
    CustomTabView(selectedTab: $selectedTab, tab: .status)
}

#Preview("Not Selected") {
    @Previewable @State var selectedTab: Tab = .status
    CustomTabView(selectedTab: $selectedTab, tab: .arrivals)
}
