//
//  TabContent.swift
//  LondonBound
//
//  Created by Adam Regan on 30/06/2026.
//

import SwiftUI

struct TabContent<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack {
            content
        }
        .foregroundColor(.theme.textPrimary)
        .padding(.horizontal, Spacing.md)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Color.theme.background)
    }
}

#Preview {
    TabContent {
        Text("Preview Content")
    }
}
