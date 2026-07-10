//
//  Header.swift
//  LondonBound
//
//  Created by Adam Regan on 01/07/2026.
//

import SwiftUI

struct Header<Trailing: View>: View {
    var title: String
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            trailing
        }
        .padding(.top, Spacing.xs)
    }
}

extension Header where Trailing == EmptyView {
    init(title: String) {
        self.init(title: title) { EmptyView() }
    }
}

#Preview {
    TabContent {
        Header(title: "Line Status")
    }
}
