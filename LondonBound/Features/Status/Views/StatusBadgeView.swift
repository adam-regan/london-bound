//
//  StatusBadgeView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct StatusBadgeView: View {
    var status: LineStatus

    var body: some View {
        Text(status.statusSeverityDescription)
            .foregroundColor(
                status.statusSeverity.condition.color.foreground
            )
            .font(.footnote)
            .padding(.vertical, Spacing.xxs)
            .padding(.horizontal, Spacing.xs)
            .background {
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .foregroundColor(
                        status.statusSeverity.condition.color.background
                    )
            }
    }
}

#Preview("Good") {
    StatusBadgeView(status: GroupedStatuses.fixture.goodService[0].lineStatuses[0])
}

#Preview("Minor") {
    StatusBadgeView(status: GroupedStatuses.fixture.disruptions[0].lineStatuses[0])
}
