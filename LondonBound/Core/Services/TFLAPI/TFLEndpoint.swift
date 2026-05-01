//
//  TFLEndpoint.swift
//  LondonBound
//
//  Created by Adam Regan on 30/04/2026.
//

enum TFLEndpoint {
    case dummyEndpoint

    var path: String {
        switch self {
        case .dummyEndpoint:
            return "/dummy/latest.json"
        }
    }
}
