//
//  TFLAPIServiceProtocol.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

protocol TFLAPIServiceProtocol {
    func request<T: Sendable & Decodable>(_ endpoint: TFLEndpoint, as type: T.Type) async throws -> T
}
