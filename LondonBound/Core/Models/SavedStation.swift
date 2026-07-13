//
//  SavedStation.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import Foundation

struct SavedStation: Sendable, Identifiable, Hashable {
    let id: String          // naptan / station id — also the arrivals query key
    let name: String
    let lat: Double
    let lon: Double
    let savedAt: Date
}

extension SavedStation {
    init(_ station: Station, savedAt: Date = .now) {
        self.init(
            id: station.id,
            name: station.name,
            lat: station.lat,
            lon: station.lon,
            savedAt: savedAt
        )
    }
}
