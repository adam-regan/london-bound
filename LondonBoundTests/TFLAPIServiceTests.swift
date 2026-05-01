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
    private let endpoint = TFLEndpoint.lineStatusByMode(modes: ["tube"])

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

    @Test @MainActor func successfulResponse_decodesLines() async throws {
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
        let lines = try await service.request(endpoint, as: [Line].self)

        #expect(lines.count == 1)
        let line = lines[0]
        #expect(line.id == "bakerloo")
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
            try await service.request(endpoint, as: [Line].self)
        }
    }

    @Test func rateLimitedResponse_throwsRateLimited() async {
        MockURLProtocol.mockData = Data()
        MockURLProtocol.mockResponse = mockResponse(statusCode: 429)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.rateLimited) {
            try await service.request(endpoint, as: [Line].self)
        }
    }

    @Test func serverErrorResponse_throwsNetworkError() async {
        MockURLProtocol.mockData = Data()
        MockURLProtocol.mockResponse = mockResponse(statusCode: 500)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.networkError) {
            try await service.request(endpoint, as: [Line].self)
        }
    }

    // MARK: - Decoding Error

    @Test func invalidJSON_throwsDecodingError() async {
        MockURLProtocol.mockData = "not json".data(using: .utf8)
        MockURLProtocol.mockResponse = mockResponse(statusCode: 200)
        MockURLProtocol.mockError = nil

        let service = makeService()

        await #expect(throws: TFLError.decodingError) {
            try await service.request(endpoint, as: [Line].self)
        }
    }
}
