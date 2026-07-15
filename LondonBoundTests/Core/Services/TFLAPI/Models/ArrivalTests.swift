//
//  ArrivalTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct ArrivalTests {
    private func makeArrival(timeToStation: Int) throws -> Arrival {
        try decodeJSON(Arrival.self, from: """
        {
            "id": "a1",
            "stationName": "Bank Underground Station",
            "lineId": "central",
            "lineName": "Central",
            "platformName": "Eastbound - Platform 3",
            "direction": "inbound",
            "destinationName": "Epping Underground Station",
            "currentLocation": "At Liverpool Street",
            "towards": "Epping",
            "timeToStation": \(timeToStation)
        }
        """)
    }

    @Test(arguments: [
        (0, "<1"),
        (59, "<1"),
        (60, "1"),
        (119, "1"),
        (120, "2"),
        (600, "10")
    ])
    func timeToStationInMinutes(seconds: Int, expected: String) throws {
        #expect(try makeArrival(timeToStation: seconds).timeToStationInMinutes == expected)
    }

    @Test func stationAndDestinationNamesAreCleaned() throws {
        let arrival = try makeArrival(timeToStation: 60)
        #expect(arrival.stationName == "Bank")
        #expect(arrival.destinationName == "Epping")
    }
}
