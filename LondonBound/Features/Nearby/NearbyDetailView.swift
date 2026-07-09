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

    init(station: NearbyStation, tflAPIService: TFLAPIServiceProtocol) {
        self.station = station
        _viewModel = StateObject(wrappedValue: NearbyDetailViewModel(tflAPIService: tflAPIService))
    }

    var body: some View {
        PageContent(navigationTitle: station.name) {
            ArrivalsList(arrivals: viewModel.arrivals)
        }
        .task {
            viewModel.fetchArrivals(stationId: station.id)
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
        tflAPIService: TFLAPIServiceStub()
    )
}
