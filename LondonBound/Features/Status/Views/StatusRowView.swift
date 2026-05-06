//
//  StatusRowView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct StatusRowView: View {
    let line: Line
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(line.color)
                .frame(width: 14)
                .overlay(
                    Circle()
                        .strokeBorder(
                            .white,
                            lineWidth: 1
                        ).opacity(0.75)
                )
            Text(line.name)
            Spacer()
            Circle()
                .foregroundColor(line.overallCondition.color.foreground)
                .frame(width: 8)
                .padding(.horizontal, Spacing.sm)
            Image(systemName: "chevron.right")
        }
        .foregroundColor(Color.theme.textPrimary)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .padding(.horizontal, Spacing.md)
        .background(Color.theme.surface)
    }
}

#Preview {
    StatusRowView(line: LondonBound.Line(id: "bakerloo", name: "Bakerloo", modeName: "tube", lineStatuses: [LondonBound.LineStatus(id: 0, statusSeverity: LondonBound.SeverityLevel(value: 10), statusSeverityDescription: "Good Service", reason: nil)]))
}
