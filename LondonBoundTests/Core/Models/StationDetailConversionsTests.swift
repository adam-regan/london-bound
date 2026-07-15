//
//  StationDetailConversionsTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct StationDetailConversionsTests {
    @Test func nearbyStation_detail_mapsFieldsAndCleansName() {
        let station = NearbyStation(
            naptanId: "N1",
            stationNaptan: nil,
            commonName: "Bank Underground Station",
            distance: 100,
            lat: 51.5,
            lon: -0.12,
            modes: ["tube"],
            lines: []
        )

        let detail = station.detail

        #expect(detail.id == "N1")
        #expect(detail.name == "Bank")   // cleaned
        #expect(detail.lat == 51.5)
        #expect(detail.lon == -0.12)
    }

    @Test func savedStation_fromDetail_andBack_roundTrips() {
        let detail = StationDetail(id: "1", name: "Bank", lat: 51.5, lon: -0.12)

        let saved = SavedStation(detail)

        #expect(saved.id == "1")
        #expect(saved.name == "Bank")
        #expect(saved.lat == 51.5)
        #expect(saved.lon == -0.12)
        #expect(saved.detail == detail)
    }
}
