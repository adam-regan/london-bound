//
//  NearbyViewModelTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

@MainActor
struct NearbyViewModelTests {
    private func makeNearbyStation(id: String = "N1", name: String = "Bank") -> NearbyStation {
        NearbyStation(
            naptanId: id,
            stationNaptan: nil,
            commonName: name,
            distance: 120,
            lat: 51.5,
            lon: -0.12,
            modes: ["tube"],
            lines: []
        )
    }

    @Test func fetchNearby_transitionsIdleToLoadingImmediately() {
        let vm = NearbyViewModel(
            tflAPIService: TFLAPIServiceMock(),
            locationProvider: LocationProviderMock()
        )

        #expect(vm.nearby == .idle)
        vm.fetchNearby()
        #expect(vm.nearby == .loading)
    }

    @Test func fetchNearby_success_setsLoaded() async throws {
        let api = TFLAPIServiceMock()
        api.nearbyResult = .success([makeNearbyStation()])
        let vm = NearbyViewModel(tflAPIService: api, locationProvider: LocationProviderMock())

        vm.fetchNearby()
        try await waitUntil { if case .loaded = vm.nearby { return true }; return false }

        #expect(vm.nearby.value?.count == 1)
    }

    @Test func fetchNearby_apiError_setsError() async throws {
        let api = TFLAPIServiceMock()
        api.nearbyResult = .failure(TFLError.rateLimited)
        let vm = NearbyViewModel(tflAPIService: api, locationProvider: LocationProviderMock())

        vm.fetchNearby()
        try await waitUntil { if case .error = vm.nearby { return true }; return false }
    }

    @Test func fetchNearby_locationError_setsError() async throws {
        let loc = LocationProviderMock()
        loc.result = .failure(LocationError.permissionDenied)
        let vm = NearbyViewModel(tflAPIService: TFLAPIServiceMock(), locationProvider: loc)

        vm.fetchNearby()
        try await waitUntil { if case .error = vm.nearby { return true }; return false }
    }
}
