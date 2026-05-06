//
//  StatusRowView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct StatusRowView: View {
    @EnvironmentObject var viewModel: StatusViewModel

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
            getStatusMarker(for: line)
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 6)
                .opacity(line.overallCondition == .good ? 0 : 1)
                .padding(.horizontal, Spacing.xxs)
        }
        .foregroundColor(Color.theme.textPrimary)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .padding(.horizontal, Spacing.sm)
        .background(Color.theme.surface)
    }

    @ViewBuilder
    func getStatusMarker(for line: Line) -> some View {
        if line.overallCondition == .good {
            StatusDotView(line: line)
        } else {
            if let worstStatus = viewModel.getWorstLineStatus(line: line) {
                StatusBadgeView(status: worstStatus)
            }
        }
    }
}

#Preview("Good") {
    StatusRowView(line: GroupedStatuses.fixture.goodService[0])
        .environmentObject(StatusViewModel(
            tflAPIService: TFLAPIService()
        ))
}

#Preview("Minor") {
    StatusRowView(line: GroupedStatuses.fixture.disruptions[0])
        .environmentObject(StatusViewModel(
            tflAPIService: TFLAPIService()
        ))
}
