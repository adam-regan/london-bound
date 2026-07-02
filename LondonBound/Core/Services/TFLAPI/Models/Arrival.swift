//
//  Arrival.swift
//  LondonBound
//
//  Created by Adam Regan on 01/07/2026.
//

import Foundation

struct Arrival: nonisolated Decodable, Sendable, Identifiable, Equatable {
    let id: String
    let stationName: String
    let lineId: LineID
    let lineName: String
    let platformName: String
    let direction: String
    let destinationName: String
    let currentLocation: String
    let towards: String
    let timeToStation: Int

    var timeToStationInMinutes: String {
        let minutes = Int(timeToStation / 60)
        if minutes < 1 {
            return "<1"
        }
        return "\(minutes)"
    }
}
