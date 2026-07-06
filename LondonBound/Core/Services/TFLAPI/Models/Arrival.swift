//
//  Arrival.swift
//  LondonBound
//
//  Created by Adam Regan on 01/07/2026.
//

import Foundation

struct Arrival: nonisolated Decodable, Sendable, Identifiable, Equatable {
    let id: String
    private let rawStationName: String
    var stationName: String { cleanStationName(rawStationName) }
    let lineId: LineID
    let lineName: String
    let platformName: String
    let direction: String?
    private let rawDestinationName: String
    var destinationName: String { cleanStationName(rawDestinationName) }
    let currentLocation: String
    let towards: String
    let timeToStation: Int

    enum CodingKeys: String, CodingKey {
        case id, rawStationName = "stationName", lineId, lineName,
             platformName, direction, rawDestinationName = "destinationName",
             currentLocation, towards, timeToStation
    }

    var timeToStationInMinutes: String {
        let minutes = Int(timeToStation / 60)
        if minutes < 1 {
            return "<1"
        }
        return "\(minutes)"
    }
}
