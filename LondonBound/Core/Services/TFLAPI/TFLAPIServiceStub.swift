//
//  TFLAPIServiceStub.swift
//  LondonBound
//
//  Created by Adam Regan on 02/07/2026.
//

#if DEBUG
struct TFLAPIServiceStub: TFLAPIServiceProtocol {
    func fetchNearby(coords: Coordinate) async throws -> [NearbyStation] {
        []
    }

    func fetchLineStatus() async throws -> [Line] {
        let fixture = GroupedStatuses.fixture
        return fixture.disruptions + fixture.goodService
    }

    func fetchStations(name: String) async throws -> StationSearchResponse {
        StationSearchResponse(query: name, total: 0, matches: [])
    }

    func fetchArrivals(stationId: String) async throws -> [Arrival] {
        []
    }
}
#endif
