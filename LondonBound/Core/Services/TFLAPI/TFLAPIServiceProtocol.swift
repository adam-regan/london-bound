//
//  TFLAPIServiceProtocol.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

protocol TFLAPIServiceProtocol {
    func fetchLineStatus() async throws -> [Line]
    func fetchStations(name: String) async throws -> StationSearchResponse
    func fetchArrivals(stationId: String) async throws -> [Arrival]
    func fetchNearby(coords: Coordinate) async throws -> [NearbyStation]
}
