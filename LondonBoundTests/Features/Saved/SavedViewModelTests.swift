//
//  SavedViewModelTests.swift
//  LondonBoundTests
//

import Foundation
@testable import LondonBound
import Testing

@MainActor
struct SavedViewModelTests {
    private func station(_ id: String) -> SavedStation {
        SavedStation(id: id, name: "Station \(id)", lat: 51.5, lon: -0.12, savedAt: .now)
    }

    @Test func stations_reflectsRepositoryInitialValue() async throws {
        let repo = SavedStationsRepositoryStub(stations: [station("1"), station("2")])
        let vm = SavedViewModel(repository: repo)

        try await waitUntil { vm.stations.count == 2 }
    }

    @Test func remove_removesStationFromPublishedList() async throws {
        let repo = SavedStationsRepositoryStub(stations: [station("1")])
        let vm = SavedViewModel(repository: repo)
        try await waitUntil { vm.stations.count == 1 }

        vm.remove(id: "1")

        try await waitUntil { vm.stations.isEmpty }
    }
}
