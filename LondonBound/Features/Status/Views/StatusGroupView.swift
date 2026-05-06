//
//  StatusGroupView.swift
//  LondonBound
//
//  Created by Adam Regan on 05/05/2026.
//

import SwiftUI

struct StatusGroupView: View {
    @EnvironmentObject var coordinator: MainCoordinator

    var groupName: String
    var lines: [Line]
    var body: some View {
        VStack {
            HStack {
                Text(groupName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 0) {
                ForEach(lines.indices, id: \.self) { index in
                    getRow(for: lines[index])
                    if index < lines.count - 1 {
                        Divider()
                            .background(
                                Color.theme.textSecondary
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.theme.surface)
            .clipShape(
                RoundedRectangle(cornerRadius: CornerRadius.md)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
            )
        }
    }

    @ViewBuilder
    func getRow(for line: Line) -> some View {
        if line.overallCondition == .good {
            StatusRowView(line: line)

        } else {
            Button {
                coordinator.push(.line(line))
            } label: {
                StatusRowView(line: line)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            StatusGroupView(
                groupName: "GOOD SERVICE",
                lines: GroupedStatuses.fixture.goodService
            )
            .environmentObject(StatusViewModel(
                tflAPIService: TFLAPIService()
            )).environmentObject(MainCoordinator())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background)
    }
}
