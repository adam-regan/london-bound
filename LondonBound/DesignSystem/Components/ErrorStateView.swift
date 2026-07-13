//
//  ErrorStateView.swift
//  LondonBound
//
//  Created by Adam Regan on 13/07/2026.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    var actionTitle: String = "Try Again"
    let action: () -> Void

    var body: some View {
        VStack(spacing: Spacing.md) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.theme.textSecondary)
            Button(actionTitle, action: action)
                .foregroundColor(Color.theme.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, Spacing.lg)
    }
}

#Preview {
    ErrorStateView(message: "Couldn't load nearby stations.") {}
}
