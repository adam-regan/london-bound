//
//  LocationProviderProtocol.swift
//  LondonBound
//
//  Created by Adam Regan on 08/07/2026.
//

protocol LocationProviderProtocol {
    func currentLocation() async throws -> Coordinate
}
