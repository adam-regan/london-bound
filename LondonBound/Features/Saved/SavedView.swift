//
//  SavedView.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import SwiftUI

struct SavedView: View {
    @ObservedObject var viewModel: SavedViewModel

    var body: some View {
        TabContent {
            Header(title: "Saved")

            if viewModel.stations.isEmpty {
                Spacer()
                Text("No saved stations yet")
                    .foregroundColor(.theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    CustomList {
                        ForEach(Array(viewModel.stations.enumerated()), id: \.element.id) { index, station in
                            ListRow {
                                Text(station.name)
                                Spacer()
                                Button {
                                    viewModel.remove(id: station.id)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.theme.textSecondary)
                                }
                                .buttonStyle(.plain)
                            }
                            if index < viewModel.stations.count - 1 {
                                Divider()
                                    .background(Color.theme.textSecondary)
                            }
                        }
                    }
                    Color.clear.frame(height: Spacing.xs)
                }
            }
        }
    }
}

#Preview {
    SavedView(
        viewModel: SavedViewModel(
            repository: SavedStationsRepositoryStub(stations: [
                SavedStation(id: "1", name: "Oxford Circus", lat: 51.515, lon: -0.1415, savedAt: .now),
                SavedStation(id: "2", name: "Victoria", lat: 51.496, lon: -0.1437, savedAt: .now)
            ])
        )
    )
}
