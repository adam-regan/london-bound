//
//  SavedView.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import SwiftUI

struct SavedView: View {
    @ObservedObject var viewModel: SavedViewModel
    @ObservedObject var coordinator: MainCoordinator
    @State private var stationToDelete: SavedStation?

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
                                Button {
                                    stationToDelete = station
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.theme.textSecondary)
                                }
                                .buttonStyle(.plain)
                                Text(station.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                coordinator.push(.stationDetail(station.detail))
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
        .alert(
            "Remove Station",
            isPresented: Binding(
                get: { stationToDelete != nil },
                set: { if !$0 { stationToDelete = nil } }
            ),
            presenting: stationToDelete
        ) { station in
            Button("Remove", role: .destructive) {
                viewModel.remove(id: station.id)
            }
            Button("Cancel", role: .cancel) {}
        } message: { station in
            Text("Remove \(station.name) from saved stations?")
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
        ),
        coordinator: MainCoordinator()
    )
}
