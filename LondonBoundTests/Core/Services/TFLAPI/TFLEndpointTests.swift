//
//  TFLEndpointTests.swift
//  LondonBoundTests
//

import Foundation
@testable import LondonBound
import Testing

struct TFLEndpointTests {
    private func value(_ items: [URLQueryItem], _ name: String) -> String? {
        items.first { $0.name == name }?.value
    }

    // Modes are derived from TransportMode.allCases in a fixed order.
    private let modes = "tube,elizabeth-line,dlr,overground"

    // MARK: - lineStatus

    @Test func lineStatus_path() {
        #expect(TFLEndpoint.lineStatus.path == "/Line/Mode/\(modes)/Status")
    }

    @Test func lineStatus_hasNoQueryItems() {
        #expect(TFLEndpoint.lineStatus.queryItems.isEmpty)
    }

    // MARK: - stationByName

    @Test func stationByName_path() {
        #expect(TFLEndpoint.stationByName(name: "bank").path == "/StopPoint/Search/bank")
    }

    @Test func stationByName_queryItems() {
        let items = TFLEndpoint.stationByName(name: "bank").queryItems
        #expect(value(items, "modes") == modes)
        #expect(value(items, "maxResults") == "10")
        #expect(value(items, "includeHubs") == "false")
    }

    // MARK: - arrivals

    @Test func arrivals_path() {
        let path = TFLEndpoint.arrivals(stationId: "940GZZ").path
        #expect(path.hasPrefix("/Line/"))
        #expect(path.hasSuffix("/Arrivals/940GZZ"))
        #expect(path.contains("bakerloo"))   // line IDs are interpolated in
    }

    @Test func arrivals_hasNoQueryItems() {
        #expect(TFLEndpoint.arrivals(stationId: "940GZZ").queryItems.isEmpty)
    }

    // MARK: - nearby

    @Test func nearby_path() {
        #expect(TFLEndpoint.nearby(coords: Coordinate(lat: 51.5, lon: -0.12)).path == "/Place")
    }

    @Test func nearby_queryItems() {
        let items = TFLEndpoint.nearby(coords: Coordinate(lat: 51.5, lon: -0.12)).queryItems
        #expect(value(items, "radius") == "3000")
        #expect(value(items, "type") == "NaptanMetroEntrance,NaptanRailEntrance")
        #expect(value(items, "lat") == "51.5")
        #expect(value(items, "lon") == "-0.12")
    }
}
