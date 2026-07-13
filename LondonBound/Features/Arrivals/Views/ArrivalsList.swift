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
    @ViewBuilder var trailing: Trailing

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let stationName = stationName {
                HStack {
                    Text(stationName)
                        .font(.title3.bold())
                    Spacer()
                    trailing
                }
            }
            switch arrivals {
            case .idle, .error:
                EmptyView()
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
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension ArrivalsList where Trailing == EmptyView {
    init(stationName: String? = nil, arrivals: Loadable<[Arrival]>) {
        self.init(stationName: stationName, arrivals: arrivals, trailing: { EmptyView() })
    }
}

#Preview {
    ArrivalsList(stationName: "Euston Station", arrivals: .idle)
}
