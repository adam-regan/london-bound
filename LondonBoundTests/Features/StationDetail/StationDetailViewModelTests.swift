//
//  StationDetailViewModelTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

@MainActor
struct StationDetailViewModelTests {
    private let detail = StationDetail(id: "1", name: "Bank", lat: 51.5, lon: -0.12)

    @Test func isSaved_falseWhenNotInRepository() async throws {
        let vm = StationDetailViewModel(
            station: detail,
            tflAPIService: TFLAPIServiceMock(),
            savedStationsRepository: SavedStationsRepositoryStub()
        )

        try await waitUntil { vm.isSaved == false }
    }

    @Test func isSaved_trueWhenStationInRepository() async throws {
        let repo = SavedStationsRepositoryStub(stations: [SavedStation(detail)])
        let vm = StationDetailViewModel(
            station: detail,
            tflAPIService: TFLAPIServiceMock(),
            savedStationsRepository: repo
        )

        try await waitUntil { vm.isSaved == true }
    }

    @Test func toggleSaved_addsThenRemoves() async throws {
        let repo = SavedStationsRepositoryStub()
        let vm = StationDetailViewModel(
            station: detail,
            tflAPIService: TFLAPIServiceMock(),
            savedStationsRepository: repo
        )
        try await waitUntil { vm.isSaved == false }

        vm.toggleSaved()
        try await waitUntil { vm.isSaved == true }

        vm.toggleSaved()
        try await waitUntil { vm.isSaved == false }
    }

    @Test func fetchArrivals_success_setsLoaded() async throws {
        let api = TFLAPIServiceMock()
        api.arrivalsResult = .success([])
        let vm = StationDetailViewModel(
            station: detail,
            tflAPIService: api,
            savedStationsRepository: SavedStationsRepositoryStub()
        )

        vm.fetchArrivals()
        try await waitUntil { if case .loaded = vm.arrivals { return true }; return false }
    }
}
