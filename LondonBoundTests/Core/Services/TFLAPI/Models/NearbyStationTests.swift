//
//  NearbyStationTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct NearbyStationTests {
    private func station(
        naptanId: String = "N1",
        stationNaptan: String? = nil,
        commonName: String = "Bank Underground Station",
        distance: Double = 0
    ) -> NearbyStation {
        NearbyStation(
            naptanId: naptanId,
            stationNaptan: stationNaptan,
            commonName: commonName,
            distance: distance,
            lat: 51.5,
            lon: -0.12,
            modes: ["tube"],
            lines: []
        )
    }

    @Test(arguments: [
        (50.0, "<100m"),
        (99.0, "<100m"),
        (100.0, "100m"),
        (145.0, "150m"),
        (144.0, "140m"),
        (1000.0, "1.0km"),
        (1500.0, "1.5km")
    ])
    func formattedDistance(distance: Double, expected: String) {
        #expect(station(distance: distance).formattedDistance == expected)
    }

    @Test func id_prefersStationNaptanOverNaptanId() {
        #expect(station(naptanId: "N1", stationNaptan: "S9").id == "S9")
        #expect(station(naptanId: "N1", stationNaptan: nil).id == "N1")
    }

    @Test func name_isCleaned() {
        #expect(station(commonName: "Canary Wharf DLR Station").name == "Canary Wharf (DLR)")
    }
}
