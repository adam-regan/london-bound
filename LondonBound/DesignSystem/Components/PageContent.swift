//
//  PageContent.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import SwiftUI

struct PageContent<Content: View>: View {
    var navigationTitle: String
    @ViewBuilder let content: Content
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(
                        "Back",
                        systemImage: "chevron.left",
                        action: dismiss.callAsFunction
                    )
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(navigationTitle)
                    .font(.title)
            }
            .foregroundStyle(Color.theme.textPrimary)
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, Spacing.md)
        .background(Color.theme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        PageContent(navigationTitle: "Navigation Title") {
            VStack {
                Text("Test Text").foregroundStyle(.textPrimary).font(.title3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
