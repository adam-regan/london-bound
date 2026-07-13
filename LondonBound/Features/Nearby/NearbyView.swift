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
                            ListRow {
                                Text(stop.name)
                                Spacer()
                                Text(stop.formattedDistance)
                                    .font(.subheadline)
                                Image(systemName: "chevron.right")
                            }
                            .onTapGesture {
                                coordinator.push(.stationDetail(stop.detail))
                            }
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
        VStack(spacing: Spacing.md) {
            if isLocationDenied(error) {
                Text("Location access is turned off.\nEnable it in Settings to see nearby stations.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.theme.textSecondary)
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }
                .foregroundColor(Color.theme.primary)
            } else {
                Text("Couldn't load nearby stations.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.theme.textSecondary)
                Button("Try Again") {
                    viewModel.fetchNearby()
                }
                .foregroundColor(Color.theme.primary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, Spacing.lg)
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
