//
//  TransportMode.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

enum TransportMode: CaseIterable {
    case tube, elizabeth, dlr, overground

    var apiKey: String {
        switch self {
        case .elizabeth:
            "elizabeth-line"
        default:
            "\(self)"
        }
    }
}
