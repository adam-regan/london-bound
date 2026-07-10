//
//  NearbyDetailView.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import SwiftUI

struct NearbyDetailView: View {
    let station: NearbyStation
    @StateObject private var viewModel: NearbyDetailViewModel

    init(station: NearbyStation, dependencies: AppDependencies) {
        self.station = station
        _viewModel = StateObject(wrappedValue: NearbyDetailViewModel(
            station: station,
            tflAPIService: dependencies.tflAPIService,
            savedStationsRepository: dependencies.savedStationsRepository
        ))
    }

    var body: some View {
        PageContent(navigationTitle: station.name) {
            ArrivalsList(arrivals: viewModel.arrivals)
        } trailing: {
            Button {
                viewModel.toggleSaved()
            } label: {
                Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                    .imageScale(.large)
            }
            .foregroundStyle(Color.theme.textPrimary)
        }
        .task {
            viewModel.fetchArrivals()
        }
    }
}

#Preview {
    NearbyDetailView(
        station: NearbyStation(
            naptanId: "940GZZLUOXC",
            stationNaptan: "940GZZLUOXC",
            commonName: "Oxford Circus Underground Station",
            distance: 250,
            lat: 51.515,
            lon: -0.1415,
            modes: ["tube"],
            lines: []
        ),
        dependencies: .preview
    )
}
