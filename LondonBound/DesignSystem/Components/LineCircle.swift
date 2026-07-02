//
//  LineCircle.swift
//  LondonBound
//
//  Created by Adam Regan on 01/07/2026.
//

import SwiftUI

struct LineCircle: View {
    var lineID: LineID
    var body: some View {
        Circle()
            .foregroundColor(lineID.color)
            .frame(width: 14)
            .overlay(
                Circle()
                    .strokeBorder(
                        .white,
                        lineWidth: 1
                    ).opacity(0.75)
            )
    }
}

#Preview {
    LineCircle(lineID: .circle)
}
