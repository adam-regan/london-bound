//
//  ArrivalsCacheTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Foundation
import Testing

@MainActor
struct ArrivalsCacheTests {
    private let base = Date(timeIntervalSince1970: 1_000_000)

    private func makeArrival(id: String) throws -> Arrival {
        try decodeJSON(Arrival.self, from: """
        {
            "id": "\(id)",
            "stationName": "Bank Underground Station",
            "lineId": "central",
            "lineName": "Central",
            "platformName": "Eastbound - Platform 3",
            "direction": "inbound",
            "destinationName": "Epping Underground Station",
            "currentLocation": "At Liverpool Street",
            "towards": "Epping",
            "timeToStation": 60
        }
        """)
    }

    @Test func read_unknownStation_returnsNil() {
        let cache = ArrivalsCache()
        #expect(cache.arrivals(for: "missing") == nil)
    }

    @Test func store_thenReadWithinWindow_returnsArrivals() throws {
        let cache = ArrivalsCache()
        let arrivals = [try makeArrival(id: "a1")]

        cache.store(arrivals, for: "bank", now: base)

        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(29)) == arrivals)
    }

    @Test func read_atTTLBoundary_returnsNil() throws {
        let cache = ArrivalsCache()   // ttl: 30
        cache.store([try makeArrival(id: "a1")], for: "bank", now: base)

        // Freshness is `< ttl`, so exactly ttl seconds later is already stale.
        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(30)) == nil)
    }

    @Test func read_pastTTL_evictsEntry() throws {
        let cache = ArrivalsCache()
        cache.store([try makeArrival(id: "a1")], for: "bank", now: base)

        // A stale read returns nil...
        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(31)) == nil)
        // ...and drops the entry: a later read back inside the original window
        // is still nil because it was evicted, not merely time-filtered.
        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(1)) == nil)
    }

    @Test func store_overwritesPreviousEntry() throws {
        let cache = ArrivalsCache()
        cache.store([try makeArrival(id: "old")], for: "bank", now: base)
        cache.store([try makeArrival(id: "new")], for: "bank", now: base.addingTimeInterval(5))

        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(6))?.map(\.id) == ["new"])
    }

    @Test func entriesAreKeyedPerStation() throws {
        let cache = ArrivalsCache()
        cache.store([try makeArrival(id: "a1")], for: "bank", now: base)
        cache.store([try makeArrival(id: "b1")], for: "oxford", now: base)

        #expect(cache.arrivals(for: "bank", now: base)?.map(\.id) == ["a1"])
        #expect(cache.arrivals(for: "oxford", now: base)?.map(\.id) == ["b1"])
    }

    @Test func customTTL_isRespected() throws {
        let cache = ArrivalsCache(ttl: 5)
        cache.store([try makeArrival(id: "a1")], for: "bank", now: base)

        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(4)) != nil)
        #expect(cache.arrivals(for: "bank", now: base.addingTimeInterval(5)) == nil)
    }
}
