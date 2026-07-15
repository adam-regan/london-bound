//
//  TFLAPIService.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

import Foundation

final class TFLAPIService: TFLAPIServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchLineStatus() async throws -> [Line] {
        try await request(.lineStatus)
    }

    func fetchStations(name: String) async throws -> StationSearchResponse {
        try await request(.stationByName(name: name))
    }

    func fetchNearby(coords: Coordinate) async throws -> [NearbyStation] {
        let response: NearbyStationsResponse = try await request(.nearby(coords: coords))
        let validModes = Set(TransportMode.allCases.map(\.apiKey))
        var seen = Set<String>()
        return response.places.filter { station in
            station.modes.contains(where: { validModes.contains($0) })
            && seen.insert(station.name).inserted
        }
    }

    func fetchArrivals(stationId: String) async throws -> [Arrival] {
        let lossy: LossyDecodableArray<Arrival> = try await request(.arrivals(stationId: stationId))
        var seen = Set<String>()
        let filtered: [Arrival] = lossy.elements.filter {
            if let timeInMins = Int($0.timeToStationInMinutes) {
                seen.insert($0.id).inserted && timeInMins <= 90
            } else {
                seen.insert($0.id).inserted
            }
        }

        return filtered.sorted { $0.timeToStation < $1.timeToStation }
    }

    private func request<T: Sendable & Decodable>(_ endpoint: TFLEndpoint) async throws -> T {
        guard let url = buildURL(endpoint) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TFLError.networkError
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            switch httpResponse.statusCode {
            case 404:
                throw TFLError.notFound
            case 429:
                throw TFLError.rateLimited
            default:
                throw TFLError.networkError
            }
        }

        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw TFLError.decodingError
        }
    }

    private func buildURL(_ endpoint: TFLEndpoint) -> URL? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "TFL_API_KEY") as? String ?? ""
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.tfl.gov.uk"
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems + [URLQueryItem(name: "app_key", value: apiKey)]
        return components.url
    }
}
