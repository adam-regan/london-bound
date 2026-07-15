//
//  TFLAPIServiceTests.swift
//  LondonBoundTests
//
//  Created by Adam Regan on 01/05/2026.
//

import Foundation
@testable import LondonBound
import Testing

@Suite(.serialized)
struct TFLAPIServiceTests {
    private func makeService() -> TFLAPIService {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return TFLAPIService(session: session)
    }

    private func mockResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://api.tfl.gov.uk")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    // MARK: - Success

    @Test func successfulResponse_decodesLines() async throws {
        let json = """
        [
            {
                "id": "bakerloo",
                "name": "Bakerloo",
                "modeName": "tube",
                "lineStatuses": [
                    {
                        "id": 0,
                        "statusSeverity": 10,
                        "statusSeverityDescription": "Good Service",
                        "reason": null
                    }
                ]
            }
        ]
        """

        MockURLProtocol.mockData = json.data(using: .utf8)
        MockURLProtocol.mockResponse = mockResponse(statusCode: 200)
        MockURLProtocol.mockError = nil

        let service = makeService()
        let lines = try await service.fetchLineStatus()

        #expect(lines.count == 1)
        let line = lines[0]
        #expect(line.id == .bakerloo)
        #expect(line.name == "Bakerloo")
        #expect(line.modeName == "tube")
        #expect(line.lineStatuses[0].statusSeverityDescription == "Good Service")
    }

    // MARK: - Error Status Codes

    @Test func notFoundResponse_throwsNotFound() async {
        MockURLProtocol.mockData = Data()
        MockURLProtocol.mockResponse = mockResponse(statusCode: 404)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.notFound) {
            try await service.fetchLineStatus()
        }
    }

    @Test func rateLimitedResponse_throwsRateLimited() async {
        MockURLProtocol.mockData = Data()
        MockURLProtocol.mockResponse = mockResponse(statusCode: 429)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.rateLimited) {
            try await service.fetchLineStatus()
        }
    }

    @Test func serverErrorResponse_throwsNetworkError() async {
        MockURLProtocol.mockData = Data()
        MockURLProtocol.mockResponse = mockResponse(statusCode: 500)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.networkError) {
            try await service.fetchLineStatus()
        }
    }

    // MARK: - Decoding Error

    @Test func invalidJSON_throwsDecodingError() async {
        MockURLProtocol.mockData = "not json".data(using: .utf8)
        MockURLProtocol.mockResponse = mockResponse(statusCode: 200)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.decodingError) {
            try await service.fetchLineStatus()
        }
    }

    // MARK: - fetchNearby transform (filter invalid modes + dedupe by name)

    @Test func fetchNearby_filtersInvalidModesAndDedupesByName() async throws {
        let json = """
        {"places": [
            {"naptanId":"1","commonName":"Bank Underground Station","distance":100,"lat":51,"lon":0,"modes":["tube"],"lines":[]},
            {"naptanId":"2","commonName":"Bank Underground Station","distance":200,"lat":51,"lon":0,"modes":["tube"],"lines":[]},
            {"naptanId":"3","commonName":"Somewhere Bus Station","distance":300,"lat":51,"lon":0,"modes":["bus"],"lines":[]},
            {"naptanId":"4","commonName":"Waterloo Station","distance":400,"lat":51,"lon":0,"modes":["dlr"],"lines":[]}
        ]}
        """
        MockURLProtocol.mockData = json.data(using: .utf8)
        MockURLProtocol.mockResponse = mockResponse(statusCode: 200)
        MockURLProtocol.mockError = nil

        let service = makeService()
        let stations = try await service.fetchNearby(coords: Coordinate(lat: 51, lon: 0))

        // "2" dropped (duplicate name "Bank"), "3" dropped (no valid mode).
        #expect(stations.map(\.id) == ["1", "4"])
        #expect(stations.map(\.name) == ["Bank", "Waterloo"])
    }

    // MARK: - fetchArrivals transform (dedupe by id + drop >90min + sort by time)

    private func arrivalJSON(id: String, time: Int) -> String {
        """
        {"id":"\(id)","stationName":"Bank Underground Station","lineId":"central","lineName":"Central","platformName":"P1","direction":"inbound","destinationName":"Epping Underground Station","currentLocation":"x","towards":"y","timeToStation":\(time)}
        """
    }

    @Test func fetchArrivals_dedupesFiltersOver90AndSortsAscending() async throws {
        let elements = [
            arrivalJSON(id: "a", time: 300),   // 5 min
            arrivalJSON(id: "b", time: 60),    // 1 min
            arrivalJSON(id: "a", time: 120),   // duplicate id -> dropped
            arrivalJSON(id: "c", time: 6000),  // 100 min -> dropped (>90)
            arrivalJSON(id: "d", time: 30)     // <1 min -> kept
        ]
        MockURLProtocol.mockData = "[\(elements.joined(separator: ","))]".data(using: .utf8)
        MockURLProtocol.mockResponse = mockResponse(statusCode: 200)
        MockURLProtocol.mockError = nil

        let service = makeService()
        let arrivals = try await service.fetchArrivals(stationId: "940GZZ")

        #expect(arrivals.map(\.id) == ["d", "b", "a"])
    }

    @Test func fetchArrivals_skipsMalformedElements() async throws {
        let json = """
        [
            \(arrivalJSON(id: "a", time: 120)),
            {"id":"broken"},
            \(arrivalJSON(id: "b", time: 60))
        ]
        """
        MockURLProtocol.mockData = json.data(using: .utf8)
        MockURLProtocol.mockResponse = mockResponse(statusCode: 200)
        MockURLProtocol.mockError = nil

        let service = makeService()
        let arrivals = try await service.fetchArrivals(stationId: "940GZZ")

        #expect(arrivals.map(\.id) == ["b", "a"])
    }
}
