//
//  TabContentView.swift
//  StoryPlayer
//
//  Created by Adam Regan on 19/02/2026.
//

import SwiftUI

struct TabContentView<Content: View>: View {
    var headerImageSystemName: String
    var headerTitle: String
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: headerImageSystemName)
                    Text(headerTitle)
                    Spacer()
                }
                .padding(.horizontal, Spacing.lg)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                ScrollView {
                    content
                }
                .scrollIndicators(.hidden)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    NavigationStack {
        TabContentView(headerImageSystemName: "book.pages", headerTitle: "Hello") {
            Text("Hello World").padding()
        }
    }
}
