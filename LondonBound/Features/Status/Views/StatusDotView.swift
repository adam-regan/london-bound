//
//  StatusDotView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct StatusDotView: View {
    var line: Line
    var body: some View {
        Circle()
            .foregroundColor(line.overallCondition.color.foreground)
            .frame(width: 8)
            .padding(.horizontal, Spacing.xxs)
    }
}

#Preview("Good") {
    StatusDotView(line: GroupedStatuses.fixture.goodService[0])
}

#Preview("Minor") {
    StatusDotView(line: GroupedStatuses.fixture.disruptions[0])
}
