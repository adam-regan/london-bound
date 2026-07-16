//
//  StationDetailView.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import SwiftUI

struct StationDetailView: View {
    let station: StationDetail
    @StateObject private var viewModel: StationDetailViewModel

    init(station: StationDetail, dependencies: AppDependencies) {
        self.station = station
        _viewModel = StateObject(wrappedValue: StationDetailViewModel(
            station: station,
            tflAPIService: dependencies.tflAPIService,
            savedStationsRepository: dependencies.savedStationsRepository,
            arrivalsCache: dependencies.arrivalsCache
        ))
    }

    var body: some View {
        PageContent(navigationTitle: station.name) {
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("ARRIVALS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.textSecondary)
                        .accessibilityAddTraits(.isHeader)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ArrivalsList(arrivals: viewModel.arrivals) {
                    viewModel.fetchArrivals()
                }
            }
        } trailing: {
            Button {
                viewModel.toggleSaved()
            } label: {
                Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                    .imageScale(.large)
            }
            .foregroundStyle(Color.theme.textPrimary)
            .accessibilityLabel("Save station")
            .accessibilityAddTraits(viewModel.isSaved ? .isSelected : [])
        }
        .task {
            viewModel.fetchArrivals()
        }
    }
}

#Preview {
    StationDetailView(
        station: StationDetail(
            id: "940GZZLUOXC",
            name: "Oxford Circus",
            lat: 51.515,
            lon: -0.1415
        ),
        dependencies: .preview
    )
}
