//
//  PageContent.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import SwiftUI

struct PageContent<Content: View, Trailing: View>: View {
    var navigationTitle: String
    @ViewBuilder let content: Content
    @ViewBuilder var trailing: Trailing
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
                    Spacer()
                    trailing
                }
                .frame(maxWidth: .infinity)
                Text(navigationTitle)
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
            }
            .foregroundStyle(Color.theme.textPrimary)
            .padding(.bottom, Spacing.xs)
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, Spacing.md)
        .background(Color.theme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension PageContent where Trailing == EmptyView {
    init(navigationTitle: String, @ViewBuilder content: () -> Content) {
        self.init(navigationTitle: navigationTitle, content: content, trailing: { EmptyView() })
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
