//
//  StationSearchField.swift
//  LondonBound
//
//  Created by Adam Regan on 15/07/2026.
//

import SwiftUI

struct StationSearchField: View {
    @Binding var query: String
    let results: Loadable<[Station]>
    @FocusState.Binding var focused: Bool
    var savedIDs: Set<String> = []
    var onSelect: (Station) -> Void

    var body: some View {
        let label = "Search Stations"
        return TextField(label, text: $query, prompt: Text(label).foregroundStyle(.textSecondary))
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
            .focused($focused)
            .overlay(alignment: .top) { resultsOverlay }
            .zIndex(1)
    }

    @ViewBuilder
    private var resultsOverlay: some View {
        let rowHeight: CGFloat = 50

        switch results {
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

        case .loaded(let stations):
            if !stations.isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(stations) { station in
                            HStack {
                                Text(station.name)
                                Spacer()
                                if savedIDs.contains(station.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.textSecondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: rowHeight)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard !savedIDs.contains(station.id) else { return }
                                onSelect(station)
                                focused = false
                            }
                            if station != stations.last {
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
                .frame(height: rowHeight * min(CGFloat(stations.count), 5))
                .offset(y: rowHeight)
                .scrollIndicators(.hidden)
            }
        }
    }
}
