//
//  Station.swift
//  LondonBound
//
//  Created by Adam Regan on 29/06/2026.
//

struct Station: nonisolated Decodable, Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let icsId: String
    let zone: String
    let lat: Double
    let lon: Double
}
