//
//  Tab.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

enum Tab: CaseIterable {
    case status, arrivals, nearby, saved

    var label: String {
        switch self {
        case .status:
            "Status"
        case .arrivals:
            "Arrivals"
        case .nearby:
            "Nearby"
        case .saved:
            "Saved"
        }
    }

    var imageSystemName: String {
        switch self {
        case .status:
            "tram.fill"
        case .arrivals:
            "clock.fill"
        case .nearby:
            "location.fill"
        case .saved:
            "bookmark.fill"
        }
    }
}
