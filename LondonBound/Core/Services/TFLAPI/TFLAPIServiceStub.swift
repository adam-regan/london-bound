//
//  TFLAPIServiceStub.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

#if DEBUG
struct TFLAPIServiceStub: TFLAPIServiceProtocol {
    var suspended = false
    var error: TFLError?

    private func forceBehaviour() async throws {
        if suspended { try await Task.sleep(for: .seconds(1_000_000)) }
        if let error = error {
            throw error
        }
    }


    func fetchNearby(coords: Coordinate) async throws -> [NearbyStation] {
        try await forceBehaviour()
        return []
    }

    func fetchLineStatus() async throws -> [Line] {
        try await forceBehaviour()

        let fixture = GroupedStatuses.fixture
        return fixture.disruptions + fixture.goodService
    }

    func fetchStations(name: String) async throws -> StationSearchResponse {
        try await forceBehaviour()

        return StationSearchResponse(query: name, total: 0, matches: [])
    }

    func fetchArrivals(stationId: String) async throws -> [Arrival] {
        try await forceBehaviour()

        return []
    }
}
#endif
