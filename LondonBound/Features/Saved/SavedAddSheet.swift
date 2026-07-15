//
//  SavedAddSheet.swift
//  LondonBound
//
//  Created by Adam Regan on 15/07/2026.
//

import SwiftUI

struct SavedAddSheet: View {
    @StateObject private var viewModel: SavedAddViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var searchFocused: Bool
    @State private var addedName: String?
    @State private var feedbackTrigger = 0

    init(dependencies: AppDependencies) {
        _viewModel = StateObject(wrappedValue: SavedAddViewModel(
            tflAPIService: dependencies.tflAPIService,
            savedStationsRepository: dependencies.savedStationsRepository
        ))
    }

    var body: some View {
        TabContent {
            Header(title: "Add Station") {
                Button("Done") { dismiss() }
                    .foregroundStyle(Color.theme.textPrimary)
            }
            StationSearchField(
                query: $viewModel.searchQuery,
                results: viewModel.searchResults,
                focused: $searchFocused,
                savedIDs: viewModel.savedIDs,
                onSelect: { station in
                    viewModel.add(station)
                    viewModel.reset()
                    addedName = station.name
                    feedbackTrigger += 1
                }
            )
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            searchFocused = false
            viewModel.reset()
        }
        .sensoryFeedback(.success, trigger: feedbackTrigger)
        .overlay(alignment: .bottom) {
            if let addedName {
                Text("Added \(addedName)")
                    .foregroundStyle(.textPrimary)
                    .padding(.horizontal, Spacing.md)
                    .frame(height: 50)
                    .background(.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .strokeBorder(Color.theme.textSecondary, lineWidth: 1).opacity(0.75)
                    )
                    .shadow(color: .white.opacity(0.2), radius: 8, y: 4)
                    .padding(.bottom, Spacing.md)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: addedName)
        .task(id: feedbackTrigger) {
            guard addedName != nil else { return }
            try? await Task.sleep(for: .seconds(1.5))
            addedName = nil
        }
    }
}

#Preview {
    SavedAddSheet(dependencies: .preview)
}
