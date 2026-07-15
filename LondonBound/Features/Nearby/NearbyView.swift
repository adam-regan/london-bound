//
//  SwiftUIView.swift
//  LondonBound
//
//  Created by Adam Regan on 06/07/2026.
//

import SwiftUI

struct NearbyView: View {
    @ObservedObject var viewModel: NearbyViewModel
    @ObservedObject var coordinator: MainCoordinator
    @Environment(\.openURL) private var openURL

    var body: some View {
        TabContent {
            Header(title: "Nearby")

            switch viewModel.nearby {
            case .idle:
                EmptyView()
            case .loading:
                SkeletonList(rowCount: 8, showsLeadingCircle: false)
            case .error(let error):
                errorView(for: error)
            case .loaded(let nearby):
                ScrollView {
                    CustomList {
                        ForEach(Array(nearby.enumerated()), id: \.element.id) { index, stop in
                            Button {
                                coordinator.push(.stationDetail(stop.detail))
                            } label: {
                                ListRow {
                                    Text(stop.name)
                                    Spacer()
                                    Text(stop.formattedDistance)
                                        .font(.subheadline)
                                    Image(systemName: "chevron.right")
                                        .accessibilityHidden(true)
                                }
                            }
                            .buttonStyle(.plain)
                            if index < nearby.count - 1 {
                                Divider()
                                    .background(
                                        Color.theme.textSecondary
                                    )
                            }
                        }
                    }
                    Color.clear.frame(height: Spacing.xs)
                }
            }
        }
        .task {
            viewModel.fetchNearby()
        }
    }

    @ViewBuilder
    private func errorView(for error: Error) -> some View {
        if isLocationDenied(error) {
            ErrorStateView(
                message: "Location access is turned off.\nEnable it in Settings to see nearby stations.",
                actionTitle: "Open Settings"
            ) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }
        } else {
            ErrorStateView(message: "Couldn't load nearby stations.") {
                viewModel.fetchNearby()
            }
        }
    }

    private func isLocationDenied(_ error: Error) -> Bool {
        if case LocationError.permissionDenied = error { return true }
        return false
    }
}

#Preview {
    NearbyView(
        viewModel: NearbyViewModel(
            tflAPIService: TFLAPIServiceStub(),
            locationProvider: LocationProviderStub()
        ),
        coordinator: MainCoordinator()
    )
}

#Preview("Loading") {
    NearbyView(
        viewModel: NearbyViewModel(
            tflAPIService: TFLAPIServiceStub(),
            locationProvider: LocationProviderStub(suspended: true)
        ),
        coordinator: MainCoordinator()
    )
}
