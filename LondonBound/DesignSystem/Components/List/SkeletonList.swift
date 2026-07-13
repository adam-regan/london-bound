//
//  SkeletonList.swift
//  LondonBound
//
//  Created by Adam Regan on 13/07/2026.
//

import SwiftUI

struct SkeletonList: View {
    var rowCount: Int = 5
    var showsLeadingCircle: Bool = true

    var body: some View {
        CustomList {
            ForEach(0 ..< rowCount, id: \.self) { index in
                ListRow {
                    if showsLeadingCircle {
                        Circle()
                            .frame(width: 8, height: 8)
                    }
                    RoundedRectangle(cornerRadius: CornerRadius.sm)
                        .frame(width: placeholderWidth(index), height: 14)
                    Spacer()
                }
                .opacity(0.6)
                .foregroundStyle(Color.theme.textSecondary.opacity(0.25))

                if index < rowCount - 1 {
                    Divider()
                        .background(Color.theme.textSecondary)
                }
            }
        }
        .shimmer()
    }

    private func placeholderWidth(_ index: Int) -> CGFloat {
        let widths: [CGFloat] = [80, 60, 100, 70, 90]
        return widths[index % widths.count]
    }
}

#Preview {
    SkeletonList(rowCount: 5)
        .padding()
}
