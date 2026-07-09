//
//  ArrivalsList.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

import SwiftUI

struct ArrivalsList: View {
    var stationName: String?
    var arrivals: Loadable<[Arrival]>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let stationName = stationName {
                Text(stationName)
                    .font(.title3.bold())
            }
            switch arrivals {
            case .idle, .error:
                EmptyView()
            case .loading:
                ProgressView()
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

#Preview {
    ArrivalsList(stationName: "Euston Station", arrivals: .idle)
}
