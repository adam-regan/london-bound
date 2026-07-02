//
//  StationSearchResponse.swift
//  LondonBound
//
//  Created by Adam Regan on 30/06/2026.
//

struct StationSearchResponse: nonisolated Decodable, Sendable {
    let query: String
    let total: Int
    let matches: [Station]
}
