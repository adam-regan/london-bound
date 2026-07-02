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
            Header(title: "Arrivals")
            searchField
            if let selectedStation = viewModel.selectedStation {
                ArrivalsList(
                    stationName: selectedStation.name,
                    arrivals: viewModel.arrivals
                )
            }
        }
    }

    private var searchField: some View {
        let label = "Search Stations"
        return TextField(label, text: $viewModel.searchQuery, prompt: Text(label).foregroundStyle(.textSecondary))
            .textFieldStyle(.plain)
            .padding(.horizontal, Spacing.md)
            .frame(height: 50)
            .background(.surface)
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
                    .background(.surface)
                    .offset(y: rowHeight)

                case .loaded(let results):
                    if !results.isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(results) { result in
                                    Text(result.name)
                                        .frame(height: rowHeight)
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
                        .background(.surface)
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
    ArrivalsView(viewModel: ArrivalsViewModel(tflAPIService: TFLAPIServiceStub()))
}
