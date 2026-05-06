//
//  StatusBadge.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct StatusBadge: View {
    @EnvironmentObject var viewModel: StatusViewModel
    var line: Line

    var body: some View {
        if line.overallCondition == .good {
            Circle()
                .foregroundColor(line.overallCondition.color.foreground)
                .frame(width: 8)
                .padding(.horizontal, Spacing.xxs)
        } else {
            if let worstStatus = viewModel.getWorstLineStatus(line: line) {
                Text(worstStatus.statusSeverityDescription)
                    .foregroundColor(
                        worstStatus.statusSeverity.condition.color.foreground
                    )
                    .font(.footnote)
                    .padding(.vertical, Spacing.xxs)
                    .padding(.horizontal, Spacing.xs)
                    .background {
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .foregroundColor(
                                worstStatus.statusSeverity.condition.color.background
                            )
                    }
            }
        }
    }
}

#Preview("Good") {
    StatusBadge(line: LondonBound.Line(id: "bakerloo", name: "Bakerloo", modeName: "tube", lineStatuses: [LondonBound.LineStatus(id: 0, statusSeverity: LondonBound.SeverityLevel(value: 10), statusSeverityDescription: "Good Service", reason: nil)])).environmentObject(StatusViewModel(
        tflAPIService: TFLAPIService()
    ))
}

#Preview("Severe") {
    StatusBadge(line: LondonBound.Line(id: "bakerloo", name: "Bakerloo", modeName: "tube", lineStatuses: [LondonBound.LineStatus(id: 0, statusSeverity: LondonBound.SeverityLevel(value: 8), statusSeverityDescription: "Severe Delays", reason: nil)])).environmentObject(StatusViewModel(
        tflAPIService: TFLAPIService()
    ))
}
