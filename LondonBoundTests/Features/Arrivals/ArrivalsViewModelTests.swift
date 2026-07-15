//
//  ArrivalsViewModelTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

@MainActor
struct ArrivalsViewModelTests {
    private func makeStation(id: String = "940GZZ", name: String = "Bank Underground Station") throws -> Station {
        try decodeJSON(Station.self, from: """
        {"id":"\(id)","name":"\(name)","icsId":"1000013","zone":"1","lat":51.5,"lon":-0.09}
        """)
    }

    private func makeViewModel(
        api: TFLAPIServiceMock = TFLAPIServiceMock(),
        repo: SavedStationsRepositoryProtocol = SavedStationsRepositoryStub()
    ) -> ArrivalsViewModel {
        ArrivalsViewModel(
            tflAPIService: api,
            savedStationsRepository: repo,
            searchDebounce: .zero
        )
    }

    @Test func query_overTwoChars_triggersSearchAndLoads() async throws {
        let api = TFLAPIServiceMock()
        api.stationsResult = .success(
            StationSearchResponse(query: "bank", total: 1, matches: [try makeStation()])
        )
        let vm = makeViewModel(api: api)

        vm.searchQuery = "bank"

        try await waitUntil { if case .loaded = vm.searchResults { return true }; return false }
        #expect(vm.searchResults.value?.count == 1)
    }

    @Test func selectStation_setsStationAndClearsSearch() async throws {
        let vm = makeViewModel()
        let station = try makeStation()

        vm.selectStation(station)
        defer { vm.stopPolling() }

        #expect(vm.selectedStation == station)
        #expect(vm.searchQuery == "")
        if case .idle = vm.searchResults {} else { Issue.record("expected searchResults idle") }
    }

    @Test func isSelectedStationSaved_trueWhenSelectedStationInRepository() async throws {
        let station = try makeStation(id: "940GZZ")
        let repo = SavedStationsRepositoryStub(stations: [SavedStation(station)])
        let vm = makeViewModel(repo: repo)

        vm.selectStation(station)
        defer { vm.stopPolling() }

        try await waitUntil { vm.isSelectedStationSaved }
    }
}
