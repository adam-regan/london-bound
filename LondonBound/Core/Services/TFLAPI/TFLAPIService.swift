//
//  TFLAPIService.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

import Foundation

final class TFLAPIService: TFLAPIServiceProtocol {
    func request<T: Sendable & Decodable>(_ endpoint: TFLEndpoint, as type: T.Type) async throws -> T {
        guard let url = buildURL(endpoint) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
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
