//
//  TFLEndpoint.swift
//  LondonBound
//
//  Created by Adam Regan on 30/04/2026.
//

import Foundation

enum TFLEndpoint {
    case lineStatusByMode(modes: [TransportMode])

    var path: String {
        switch self {
        case .lineStatusByMode(let modes):
            let modesString = modes.map { $0.apiKey }.joined(separator: ",")
            return "/Line/Mode/\(modesString)/Status"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
}
