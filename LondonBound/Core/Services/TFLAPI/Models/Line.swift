//
//  Line.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

struct Line: nonisolated Decodable, Sendable, Identifiable {
    let id: String
    let name: String
    let modeName: String
    let lineStatuses: [LineStatus]
}
