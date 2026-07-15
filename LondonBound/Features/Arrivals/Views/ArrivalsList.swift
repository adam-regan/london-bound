//
//  ArrivalsList.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

import SwiftUI

struct ArrivalsList<Trailing: View>: View {
    var stationName: String?
    var arrivals: Loadable<[Arrival]>
    var onRetry: () -> Void
    @ViewBuilder var trailing: Trailing

    var body: some View {
        VStack(alignment: .leading) {
            if let stationName = stationName {
                HStack {
                    Text(stationName)
                        .font(.title3.bold())
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                    trailing
                }
            }
            switch arrivals {
            case .idle:
                EmptyView()
            case .error:
                ErrorStateView(message: "Couldn't load arrivals.", action: onRetry)
            case .loading:
                SkeletonList(rowCount: 6)
            case .loaded(let arrivalsList):
                ScrollView {
                    CustomList {
                        ForEach(arrivalsList) { arrival in
                            ListRow {
                                LineCircle(lineID: arrival.lineId)
                                Text(arrival.destinationName)
                                Spacer()
                                VStack {
                                    Text(arrival.timeToStationInMinutes)
                                    Text("min")
                                        .font(.footnote)
                                }
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(accessibilityLabel(for: arrival))
                            if arrival != arrivalsList.last {
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func accessibilityLabel(for arrival: Arrival) -> String {
        let minutes = arrival.timeToStationInMinutes
        let time = minutes == "<1"
            ? "due now"
            : "\(minutes) minute\(minutes == "1" ? "" : "s")"
        return "\(arrival.destinationName), \(arrival.lineName) line, \(time)"
    }
}

extension ArrivalsList where Trailing == EmptyView {
    init(stationName: String? = nil, arrivals: Loadable<[Arrival]>, onRetry: @escaping () -> Void) {
        self.init(stationName: stationName, arrivals: arrivals, onRetry: onRetry, trailing: { EmptyView() })
    }
}

#Preview {
    ArrivalsList(stationName: "Euston Station", arrivals: .idle) {}
}
