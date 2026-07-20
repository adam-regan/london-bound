//
//  StatusView.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var viewModel: StatusViewModel
    @EnvironmentObject var coordinator: MainCoordinator

    var body: some View {
        TabContent {
            Header(title: "Line Status") {
                if let timeUpdated = viewModel.timeUpdated {
                    Text("updated \(timeUpdated)")
                        .font(.subheadline)
                }
            }
            switch viewModel.statuses {
            case .idle, .loading:
                ScrollView {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: CornerRadius.sm)
                            .fill(Color.theme.textSecondary.opacity(0.25))
                            .frame(width: 140, height: 16)
                        SkeletonList(rowCount: 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollIndicators(.hidden)
            case .error:
                ErrorStateView(message: "Couldn't load line status.") {
                    viewModel.retry()
                }
            case .loaded(let statuses):
                ScrollView {
                    VStack(spacing: Spacing.sm) {
                        if !statuses.disruptions.isEmpty {
                            StatusGroupView(
                                groupName: "DISRUPTIONS",
                                lines: statuses
                                    .disruptions
                            )
                        }
                        if !statuses.goodService.isEmpty {
                            StatusGroupView(
                                groupName: "GOOD SERVICE",
                                lines: statuses
                                    .goodService
                            )
                        }
                    }
                    Color.clear.frame(height: Spacing.xs)
                }
                .scrollIndicators(.hidden)
            }
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
    StatusView()
        .environmentObject(StatusViewModel(
            tflAPIService: TFLAPIServiceStub()
        ))
        .environmentObject(MainCoordinator())
}

#Preview("Loading") {
    StatusView()
        .environmentObject(StatusViewModel(
            tflAPIService: TFLAPIServiceStub(suspended: true)
        ))
        .environmentObject(MainCoordinator())
}

#Preview("Error") {
    StatusView()
        .environmentObject(
            StatusViewModel(
                tflAPIService: TFLAPIServiceStub(error: .decodingError)
            )
        )
        .environmentObject(MainCoordinator())
}
