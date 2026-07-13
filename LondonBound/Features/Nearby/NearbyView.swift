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

    var body: some View {
        TabContent {
            Header(title: "Nearby")

            switch viewModel.nearby {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .error(let error):
                Text(error.localizedDescription)
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
                                coordinator.push(.nearbyDetails(stop))
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
