//
//  LineStatus.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

struct LineStatus: nonisolated Decodable, Sendable, Identifiable {
    let id: Int
    let statusSeverity: Int
    let statusSeverityDescription: String
    let reason: String?
}
