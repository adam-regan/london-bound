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
        NavigationStack(path: $coordinator.path) {
            TabContent {
                Header(title: "Line Status") {
                    if let timeUpdated = viewModel.timeUpdated {
                        Text("updated \(timeUpdated)")
                            .font(.subheadline)
                    }
                }
                switch viewModel.statuses {
                case .idle, .loading, .error:
                    ProgressView()
                        .tint(.textPrimary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded(let statuses):
                    ScrollView {
                        VStack {
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
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page: page)
            }
        }
        .background(Color.theme.background)
    }
}

#Preview {
    StatusView()
        .environmentObject(StatusViewModel(
            tflAPIService: TFLAPIServiceStub()
        ))
        .environmentObject(MainCoordinator())
}
