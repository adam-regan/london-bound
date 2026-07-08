//
//  LocationProviderStub.swift.swift
//  LondonBound
//
//  Created by Adam Regan on 08/07/2026.
//

import CoreLocation

#if DEBUG
struct LocationProviderStub: LocationProviderProtocol {
    let error: CLError? = nil

    func currentLocation() async throws -> Coordinate {
        if let error = error {
            throw error
        }
        return Coordinate(lat: 51.0, lon: 0.08)
    }
}

#endif
