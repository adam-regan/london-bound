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
        VStack(spacing: Spacing.sm) {
            HStack {
                Text(groupName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            CustomList {
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
        }
    }

    @ViewBuilder
    func getRow(for line: Line) -> some View {
        if line.overallCondition == .good {
            StatusRowView(line: line)

        } else {
            Button {
                coordinator.push(.lineDetail(line))
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
                tflAPIService: TFLAPIServiceStub()
            )).environmentObject(MainCoordinator())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background)
    }
}
