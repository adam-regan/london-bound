//
//  TFLAPIServiceStub.swift
//  LondonBound
//
//  Created by Adam Regan on 01/05/2026.
//

final class TFLAPIServiceStub: TFLAPIServiceProtocol {
    var result: Any?
    var error: Error?

    func request<T: Decodable>(_ endpoint: TFLEndpoint, as type: T.Type) async throws -> T {
        if let error { throw error }
        return result as! T
    }
}
