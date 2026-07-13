//
//  LocationProviderStub.swift.swift
//  LondonBound
//
//  Created by Adam Regan on 08/07/2026.
//

#if DEBUG
struct LocationProviderStub: LocationProviderProtocol {
    let error: LocationError? = nil
    var suspended = false

    func currentLocation() async throws -> Coordinate {
        if suspended {
            try await Task.sleep(for: .seconds(1_000_000))
        }
        if let error = error {
            throw error
        }
        return Coordinate(lat: 51.0, lon: 0.08)
    }
}

#endif
