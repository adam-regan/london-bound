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
            StatusBadge(line: line)
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 6)
                .opacity(line.overallCondition == .good ? 0 : 1)
                .padding(.horizontal, Spacing.xxs)
        }
        .foregroundColor(Color.theme.textPrimary)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .padding(.horizontal, Spacing.sm)
        .background(Color.theme.surface)
    }
}

#Preview {
    StatusRowView(line: LondonBound.Line(id: "bakerloo", name: "Bakerloo", modeName: "tube", lineStatuses: [LondonBound.LineStatus(id: 0, statusSeverity: LondonBound.SeverityLevel(value: 10), statusSeverityDescription: "Good Service", reason: nil)]))
}
