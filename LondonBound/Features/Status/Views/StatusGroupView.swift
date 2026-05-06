//
//  StatusGroupView.swift
//  LondonBound
//
//  Created by Adam Regan on 05/05/2026.
//

import SwiftUI

struct StatusGroupView: View {
    var groupName: String
    var lines: [Line]
    var body: some View {
        HStack {
            Text(groupName)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        VStack(spacing: 0) {
            ForEach(lines.indices, id: \.self) { index in
                let line = lines[index]
                HStack {
                    Circle()
                        .foregroundColor(line.color)
                        .frame(width: 12)
                    Text(line.name)
                        .foregroundColor(Color.theme.textPrimary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .padding(.horizontal, Spacing.md)
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
                .strokeBorder(Color.theme.textSecondary, lineWidth: 1)
        )
    }
}

#Preview {
    ScrollView {
        StatusGroupView(
            groupName: "GOOD SERVICE",
            lines: GroupedStatuses.fixture.goodService
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.theme.background)
}
