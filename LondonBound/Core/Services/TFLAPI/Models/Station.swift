//
//  Station.swift
//  LondonBound
//
//  Created by Adam Regan on 29/06/2026.
//

struct Station: nonisolated Decodable, Sendable, Identifiable, Hashable {
    let id: String
    private let rawName: String
    var name: String { cleanStationName(rawName) }

    let icsId: String
    let zone: String
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case id, rawName = "name", icsId, zone, lat, lon
    }
}
