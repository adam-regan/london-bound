//
//  DisruptionCardView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//
import SwiftUI

struct DisruptionCardView: View {
    var status: LineStatus
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(status.statusSeverityDescription)
                .font(.headline)
                .foregroundStyle(status.statusSeverity.condition.color.foreground)
            if let reason = status.reason {
                Text(reason)
                    .font(.subheadline)
                    .foregroundStyle(Color.theme.textPrimary)
            }
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.theme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
        )
        .overlay(
            HStack {
                status.statusSeverity.condition.color.foreground
                    .frame(width: Spacing.xxs)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

#Preview {
    DisruptionCardView(
        status: GroupedStatuses.fixture.disruptions[0].lineStatuses[0]
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.theme.background)
}
