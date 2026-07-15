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
        ListRow {
            LineCircle(lineID: line.id)
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let status = viewModel.getWorstLineStatus(line: line)?
            .statusSeverityDescription ?? "Good Service"
        return "\(line.name) line, \(status)"
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
            tflAPIService: TFLAPIServiceStub()
        ))
}

#Preview("Minor") {
    StatusRowView(line: GroupedStatuses.fixture.disruptions[0])
        .environmentObject(StatusViewModel(
            tflAPIService: TFLAPIServiceStub()
        ))
}
