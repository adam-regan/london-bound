//
//  SavedAddViewModelTests.swift
//  LondonBoundTests
//

import Foundation
@testable import LondonBound
import Testing

@MainActor
struct SavedAddViewModelTests {
    private func makeStation(id: String = "940GZZ", name: String = "Bank Underground Station") throws -> Station {
        try decodeJSON(Station.self, from: """
        {"id":"\(id)","name":"\(name)","icsId":"1000013","zone":"1","lat":51.5,"lon":-0.09}
        """)
    }

    private func makeViewModel(
        api: TFLAPIServiceMock = TFLAPIServiceMock(),
        repo: SavedStationsRepositoryProtocol = SavedStationsRepositoryStub()
    ) -> SavedAddViewModel {
        SavedAddViewModel(
            tflAPIService: api,
            savedStationsRepository: repo,
            searchDebounce: .zero
        )
    }

    // MARK: - Search gate

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

    @Test func query_twoCharsOrFewer_staysIdle() async throws {
        let vm = makeViewModel()

        vm.searchQuery = "ba"

        // Give the debounce a chance to fire, then confirm it stayed idle.
        try? await waitUntil(timeout: .milliseconds(200)) {
            if case .idle = vm.searchResults { return false }; return true
        }
        #expect(vm.searchResults == .idle)
    }

    @Test func searchError_resetsToIdle() async throws {
        let api = TFLAPIServiceMock()
        api.stationsResult = .success(
            StationSearchResponse(query: "bank", total: 1, matches: [try makeStation()])
        )
        let vm = makeViewModel(api: api)

        vm.searchQuery = "bank"
        try await waitUntil { if case .loaded = vm.searchResults { return true }; return false }

        api.stationsResult = .failure(TFLError.rateLimited)
        vm.searchQuery = "banks"

        try await waitUntil { if case .idle = vm.searchResults { return true }; return false }
    }

    // MARK: - savedIDs mapping

    @Test func savedIDs_reflectRepository() async throws {
        let repo = SavedStationsRepositoryStub(stations: [
            SavedStation(id: "1", name: "A", lat: 0, lon: 0, savedAt: .now),
            SavedStation(id: "2", name: "B", lat: 0, lon: 0, savedAt: .now)
        ])
        let vm = makeViewModel(repo: repo)

        try await waitUntil { vm.savedIDs == ["1", "2"] }
    }

    @Test func add_savesStationAndUpdatesSavedIDs() async throws {
        let station = try makeStation(id: "940GZZ")
        let vm = makeViewModel()

        vm.add(station)

        try await waitUntil { vm.savedIDs == ["940GZZ"] }
    }
}
