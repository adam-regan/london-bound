//
//  StatusView.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

import SwiftUI

struct StatusView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Line Status")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("updated 9:40")
            }
            .foregroundColor(.theme.textPrimary)
        }
        .padding(.horizontal, Spacing.md)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Color.theme.background)
    }
}

#Preview {
    StatusView()
}
