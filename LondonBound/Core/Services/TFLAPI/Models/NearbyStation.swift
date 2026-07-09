//
//  NearbyStation.swift
//  LondonBound
//
//  Created by Adam Regan on 08/07/2026.
//

import Foundation

struct NearbyStationsResponse: nonisolated Decodable, Sendable {
    let places: [NearbyStation]
}

struct NearbyStation: nonisolated Decodable, Sendable, Identifiable, Hashable {
    let naptanId: String
    let stationNaptan: String?
    let commonName: String
    let distance: Double
    let lat: Double
    let lon: Double
    let modes: [String]
    let lines: [NearbyLine]

    var id: String {
        stationNaptan ?? naptanId
    }

    var name: String {
        cleanStationName(commonName)
    }

    var formattedDistance: String {
        if distance >= 1000 {
            return String(format: "%.1fkm", distance / 1000)
        } else if distance >= 100 {
            let rounded = (distance / 10).rounded() * 10
            return "\(Int(rounded))m"
        } else {
            return "<100m"
        }
    }

    struct NearbyLine: Decodable, Sendable, Hashable {
        let id: String
        let name: String
    }
}
