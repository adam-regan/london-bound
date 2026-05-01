//
//  TFLEndpoint.swift
//  LondonBound
//
//  Created by Adam Regan on 30/04/2026.
//

import Foundation

enum TFLEndpoint {
    case lineStatusByMode(modes: [String])

    var path: String {
        switch self {
        case .lineStatusByMode(let modes):
            let modesString = modes.joined(separator: ",")
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
