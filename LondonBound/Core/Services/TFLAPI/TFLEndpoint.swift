//
//  TFLEndpoint.swift
//  LondonBound
//
//  Created by Adam Regan on 30/04/2026.
//

import Foundation

enum TFLEndpoint {
    case lineStatus
    case stationByName(name: String)
    case arrivals(stationId: String)
    case nearby(coords: Coordinate)

    var path: String {
        let modesString = TransportMode.allCases.map(\.apiKey).joined(separator: ",")
        let allLineIDs = LineID.allCases.map(\.rawValue).joined(separator: ",")

        switch self {
        case .lineStatus:
            return "/Line/Mode/\(modesString)/Status"
        case .stationByName(let name):
            return "/StopPoint/Search/\(name)"
        case .arrivals(let stationId):
            return "/Line/\(allLineIDs)/Arrivals/\(stationId)"
        case .nearby:
            return "/Place"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .lineStatus:
            return []
        case .stationByName:
            let modesString = TransportMode.allCases.map(\.apiKey).joined(separator: ",")
            return [
                URLQueryItem(name: "modes", value: modesString),
                URLQueryItem(name: "maxResults", value: "10"),
                URLQueryItem(name: "includeHubs", value: "false")
            ]
        case .arrivals:
            return []
        case .nearby(let coords):
            return [
                URLQueryItem(name: "radius", value: "3000"),
                URLQueryItem(name: "type", value: "NaptanMetroEntrance,NaptanRailEntrance"),
                URLQueryItem(name: "lat", value: "\(coords.lat)"),
                URLQueryItem(name: "lon", value: "\(coords.lon)")
            ]
        }
    }
}
