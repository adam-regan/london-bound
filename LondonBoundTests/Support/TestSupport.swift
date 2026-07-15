//
//  TestSupport.swift
//  LondonBoundTests
//
//  Shared mocks, fixtures, and async helpers for the unit tests.
//

import Foundation
internal import Combine
@testable import LondonBound

// MARK: - Mocks

/// Configurable TFL API mock. Each method returns its corresponding `Result`,
/// letting a test drive both success payloads and thrown errors.
final class TFLAPIServiceMock: TFLAPIServiceProtocol, @unchecked Sendable {
    var lineStatusResult: Result<[Line], Error> = .success([])
    var stationsResult: Result<StationSearchResponse, Error>
        = .success(StationSearchResponse(query: "", total: 0, matches: []))
    var arrivalsResult: Result<[Arrival], Error> = .success([])
    var nearbyResult: Result<[NearbyStation], Error> = .success([])

    func fetchLineStatus() async throws -> [Line] { try lineStatusResult.get() }
    func fetchStations(name: String) async throws -> StationSearchResponse { try stationsResult.get() }
    func fetchArrivals(stationId: String) async throws -> [Arrival] { try arrivalsResult.get() }
    func fetchNearby(coords: Coordinate) async throws -> [NearbyStation] { try nearbyResult.get() }
}

final class LocationProviderMock: LocationProviderProtocol, @unchecked Sendable {
    var result: Result<Coordinate, Error> = .success(Coordinate(lat: 51.5, lon: -0.12))

    func currentLocation() async throws -> Coordinate { try result.get() }
}

// MARK: - Fixtures

func makeStatus(severity: Int, id: Int = 0) -> LineStatus {
    LineStatus(
        id: id,
        statusSeverity: SeverityLevel(value: severity),
        statusSeverityDescription: SeverityLevel(value: severity).description,
        reason: nil
    )
}

func makeLine(
    id: LineID = .central,
    name: String = "Central",
    mode: String = "tube",
    severities: [Int] = [10]
) -> Line {
    Line(
        id: id,
        name: name,
        modeName: mode,
        lineStatuses: severities.map { makeStatus(severity: $0) }
    )
}

/// Decodes a model from a JSON string. Used where a type's memberwise init is
/// inaccessible (e.g. `Arrival` has private stored properties).
func decodeJSON<T: Decodable>(_ type: T.Type = T.self, from json: String) throws -> T {
    try JSONDecoder().decode(T.self, from: Data(json.utf8))
}

// MARK: - Async helpers

struct WaitTimeout: Error {}

/// Polls `condition` on the main actor until it is true or the timeout elapses.
/// Used to await `@Published` state that a view model updates from a detached `Task`.
@MainActor
func waitUntil(
    timeout: Duration = .seconds(2),
    _ condition: () -> Bool
) async throws {
    let clock = ContinuousClock()
    let deadline = clock.now.advanced(by: timeout)
    while !condition() {
        if clock.now >= deadline { throw WaitTimeout() }
        try await Task.sleep(for: .milliseconds(5))
    }
}
