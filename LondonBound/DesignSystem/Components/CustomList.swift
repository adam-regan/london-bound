//
//  ListRow.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

import SwiftUI

struct CustomList<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
           content
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.surface)
        .clipShape(
            RoundedRectangle(cornerRadius: CornerRadius.md)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
        )
    }
}

#Preview {
    ListRow {}
}
