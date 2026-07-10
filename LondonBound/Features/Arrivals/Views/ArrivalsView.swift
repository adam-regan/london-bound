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
            searchField
            if let selectedStation = viewModel.selectedStation {
                ArrivalsList(
                    stationName: selectedStation.name,
                    arrivals: viewModel.arrivals
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
        .task {
            viewModel.startPolling()
        }
        .onDisappear {
            viewModel.stopPolling()
        }
    }

    private var searchField: some View {
        let label = "Search Stations"
        return TextField(label, text: $viewModel.searchQuery, prompt: Text(label).foregroundStyle(.textSecondary))
            .textFieldStyle(.plain)
            .padding(.horizontal, Spacing.md)
            .frame(height: 50)
            .background(.surfaceSecondary)
            .foregroundStyle(.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
            )
            .disableAutocorrection(true)
            .focused($isSearchFocused)
            .overlay(alignment: .top) {
                let rowHeight: CGFloat = 50

                switch viewModel.searchResults {
                case .idle, .error:
                    EmptyView()

                case .loading:
                    HStack {
                        ProgressView()
                            .tint(.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: rowHeight)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
                    )
                    .shadow(color: .white.opacity(0.2), radius: 8, y: 4)
                    .background(.surfaceSecondary)
                    .offset(y: rowHeight)

                case .loaded(let results):
                    if !results.isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(results) { result in
                                    HStack {
                                        Text(result.name)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: rowHeight)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.selectStation(result)
                                        isSearchFocused.toggle()
                                    }
                                    if result != results.last {
                                        Divider()
                                            .overlay(.textSecondary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.md)
                        .background(.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
                        )
                        .shadow(color: .white.opacity(0.2), radius: 8, y: 4)
                        .frame(height: rowHeight * min(CGFloat(results.count), 5))
                        .offset(y: rowHeight)
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .zIndex(1)
    }
}

#Preview {
    ArrivalsView(viewModel: ArrivalsViewModel(tflAPIService: TFLAPIServiceStub(), savedStationsRepository: SavedStationsRepositoryStub()))
}
