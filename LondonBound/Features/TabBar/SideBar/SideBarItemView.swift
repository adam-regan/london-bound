//
//  SideBarItemView.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import SwiftUI

struct SideBarItemView: View {
    @Binding var selectedTab: Tab
    var tab: Tab

    private var isSelected: Bool {
        selectedTab == tab
    }

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: tab.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(tab.label)
                    .font(.body)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .fill(isSelected ? Color.theme.surface : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(
            isSelected ? Color.theme.primary : Color.theme.secondary
        )
    }
}
#Preview {
    @Previewable @State var selectedTab: Tab = .status
    VStack(alignment: .leading) {
        SideBarItemView(selectedTab: $selectedTab, tab: .status)
        SideBarItemView(selectedTab: $selectedTab, tab: .nearby)
    }
    .padding()
    .background(Color.theme.background)
}

