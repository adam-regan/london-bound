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
            VStack {
                HStack {
                    Text("Line Status")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    if let timeUpdated = viewModel.timeUpdated {
                        Text("updated \(timeUpdated)")
                            .font(.subheadline)
                    }
                }
                switch viewModel.statuses {
                case .loading, .error:
                    Text("Loading")
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
            .foregroundColor(.theme.textPrimary)
            .padding(.horizontal, Spacing.md)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color.theme.background)
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
    }
}

#Preview {
    StatusView().environmentObject(StatusViewModel(
        tflAPIService: TFLAPIService()
    ))
}
