//
//  LineStatus.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

struct LineStatus: nonisolated Decodable, Sendable, Identifiable, Hashable {
    let id: Int
    let statusSeverity: SeverityLevel
    let statusSeverityDescription: String
    let reason: String?
}
