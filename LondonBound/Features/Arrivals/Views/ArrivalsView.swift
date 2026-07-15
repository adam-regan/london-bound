//
//  ArrivalsView.swift
//  LondonBound
//
//  Created by Adam Regan on 30/06/2026.
//

import SwiftUI
internal import Combine

struct ArrivalsView: View {
    @ObservedObject var viewModel: ArrivalsViewModel
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        TabContent {
            Header(title: "Arrivals") {
                if let timeUpdated = viewModel.timeUpdated {
                    Text("updated \(timeUpdated)")
                        .font(.subheadline)
                }
            }
            StationSearchField(
                query: $viewModel.searchQuery,
                results: viewModel.searchResults,
                focused: $isSearchFocused,
                onSelect: { viewModel.selectStation($0) }
            )
            if let selectedStation = viewModel.selectedStation {
                ArrivalsList(
                    stationName: selectedStation.name,
                    arrivals: viewModel.arrivals,
                    onRetry: { viewModel.retryArrivals() }
                ) {
                    Button {
                        viewModel.toggleSaved()
                    } label: {
                        Image(systemName: viewModel.isSelectedStationSaved ? "bookmark.fill" : "bookmark")
                            .imageScale(.large)
                    }
                    .foregroundStyle(Color.theme.textPrimary)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
            viewModel.clearSearch()
        }
        .task {
            viewModel.startPolling()
        }
        .onDisappear {
            viewModel.stopPolling()
        }
    }
}

#Preview {
    ArrivalsView(viewModel: ArrivalsViewModel(tflAPIService: TFLAPIServiceStub(), savedStationsRepository: SavedStationsRepositoryStub()))
}
