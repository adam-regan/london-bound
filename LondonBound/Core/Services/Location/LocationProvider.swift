//
//  LocationProvider.swift
//  LondonBound
//
//  Created by Adam Regan on 06/07/2026.
//

internal import Combine
import CoreLocation

final class LocationProvider: NSObject, CLLocationManagerDelegate, LocationProviderProtocol {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<Coordinate, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func currentLocation() async throws -> Coordinate {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation?.resume(throwing: LocationError.cancelled)
            self.continuation = continuation

            if manager.authorizationStatus == .notDetermined {
                manager.requestWhenInUseAuthorization()
            } else {
                handleAuthorization()
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorization()
    }

    private func handleAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            resume(with: .failure(LocationError.permissionDenied))
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord = locations.first?.coordinate else {
            resume(with: .failure(LocationError.locationUnavailable))
            return
        }
        resume(
            with:
            .success(
                Coordinate(lat: coord.latitude, lon: coord.longitude)
            )
        )
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resume(with: .failure(error))
    }

    private func resume(with result: Result<Coordinate, Error>) {
        continuation?.resume(with: result)
        continuation = nil
    }
}
