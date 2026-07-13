//
//  TFLAPIServiceStub.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

#if DEBUG
struct TFLAPIServiceStub: TFLAPIServiceProtocol {
    var suspended = false

    private func suspendIfNeeded() async throws {
        if suspended { try await Task.sleep(for: .seconds(1_000_000)) }
    }

    func fetchNearby(coords: Coordinate) async throws -> [NearbyStation] {
        try await suspendIfNeeded()
        return []
    }

    func fetchLineStatus() async throws -> [Line] {
        try await suspendIfNeeded()
        let fixture = GroupedStatuses.fixture
        return fixture.disruptions + fixture.goodService
    }

    func fetchStations(name: String) async throws -> StationSearchResponse {
        try await suspendIfNeeded()
        return StationSearchResponse(query: name, total: 0, matches: [])
    }

    func fetchArrivals(stationId: String) async throws -> [Arrival] {
        try await suspendIfNeeded()
        return []
    }
}
#endif
