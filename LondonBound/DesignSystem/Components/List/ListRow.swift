//
//  ListRow.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

import SwiftUI

struct ListRow<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        HStack {
            content
        }
        .foregroundColor(Color.theme.textPrimary)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .padding(.horizontal, Spacing.sm)
        .background(Color.theme.surface)
    }
}

#Preview {
    ListRow {}
}
