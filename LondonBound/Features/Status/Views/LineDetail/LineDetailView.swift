//
//  LineDetailView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct LineDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var line: Line
    var body: some View {
        PageContent(navigationTitle: line.name) {
            VStack {
                ForEach(line.lineStatuses) { status in
                    DisruptionCardView(status: status)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LineDetailView(line: GroupedStatuses.fixture.disruptions[0]).environmentObject(StatusViewModel(
            tflAPIService: TFLAPIServiceStub()
        ))
    }
}
