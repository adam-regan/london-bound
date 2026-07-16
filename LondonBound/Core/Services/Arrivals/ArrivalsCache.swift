//
//  ArrivalsCache.swift
//  LondonBound
//
//  Created by Adam Regan on 16/07/2026.
//

import Foundation

@MainActor
final class ArrivalsCache {
    private struct Entry {
        let arrivals: [Arrival]
        let fetchedAt: Date
    }

    private var entries: [String: Entry] = [:]
    private let ttl: TimeInterval

    nonisolated init(ttl: TimeInterval = 30) {
        self.ttl = ttl
    }

    func arrivals(for stationId: String, now: Date = .now) -> [Arrival]? {
        guard let entry = entries[stationId] else { return nil }
        guard now.timeIntervalSince(entry.fetchedAt) < ttl else {
            entries[stationId] = nil
            return nil
        }
        return entry.arrivals
    }

    func store(_ arrivals: [Arrival], for stationId: String, now: Date = .now) {
        entries[stationId] = Entry(arrivals: arrivals, fetchedAt: now)
    }
}
