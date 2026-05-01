//
//  ContentView.swift
//  LondonBound
//
//  Created by Adam Regan on 29/04/2026.
//

import SwiftUI

struct RootView: View {
    private var service = TFLAPIService()
    @State var response: [Line] = []

    var body: some View {
        VStack {
            if response.isEmpty {
                Text("No Data")
            } else {
                ForEach(response) { line in
                    VStack(alignment: .leading) {
                        Text(line.name)
                            .font(.headline)
                            .padding(.horizontal, Spacing.md)
                        if !line.lineStatuses.isEmpty {
                            ForEach(line.lineStatuses) { status in
                                Text(status.statusSeverityDescription)
                                    .padding(.horizontal, Spacing.xl)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .task {
            do {
                response = try await service.request(.lineStatusByMode(modes: ["tube"]), as: [Line].self)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    RootView()
}
