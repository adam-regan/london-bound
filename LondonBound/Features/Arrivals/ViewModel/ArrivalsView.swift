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
                VStack(alignment: .leading) {
                    Text(selectedStation.name)
                        .font(.headline.bold())
                    ScrollView {
                        VStack {
                            VStack(spacing: 0) {
                                ForEach(viewModel.arrivals) { arrival in
                                    HStack {
                                        LineCircle(lineID: arrival.lineId)
                                        Text(arrival.destinationName)
                                        Spacer()
                                        VStack {
                                            Text(arrival.timeToStationInMinutes)
                                            Text("min")
                                                .font(.footnote)
                                        }
                                    }
                                    .foregroundColor(Color.theme.textPrimary)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .frame(height: 44)
                                    .padding(.horizontal, Spacing.sm)
                                    .background(Color.theme.surface)
                                    if arrival != viewModel.arrivals.last {
                                        Divider()
                                            .background(
                                                Color.theme.textSecondary
                                            )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.theme.surface)
                            .clipShape(
                                RoundedRectangle(cornerRadius: CornerRadius.md)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                    .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                if !viewModel.searchResults.isEmpty {
                    let rowHeight: CGFloat = 44

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.searchResults) { result in
                                Text(result.name)
                                    .frame(height: rowHeight)
                                    .onTapGesture {
                                        viewModel.selectStation(result)
                                        isSearchFocused.toggle()
                                    }
                                if result != viewModel.searchResults.last {
                                    Divider()
                                        .overlay(.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                    .background(.surface)
                    .frame(height: rowHeight * min(CGFloat(viewModel.searchResults.count), 5))
                    .offset(y: 50)
                    .scrollIndicators(.hidden)
                }
            }
            .zIndex(1)
    }
}

#Preview {
    ArrivalsView(viewModel: ArrivalsViewModel(tflAPIService: TFLAPIServiceStub()))
}
