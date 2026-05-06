//
//  DisruptionDetailView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

struct DisruptionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var line: Line
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
                Text(line.name)
                    .font(.title)
            }
            .foregroundStyle(Color.theme.textPrimary)
            VStack {
                ForEach(line.lineStatuses) { status in
                    DisruptionCardView(status: status)
                }
            }
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
        DisruptionDetailView(line: GroupedStatuses.fixture.disruptions[0]).environmentObject(StatusViewModel(
            tflAPIService: TFLAPIService()
        ))
    }
}
