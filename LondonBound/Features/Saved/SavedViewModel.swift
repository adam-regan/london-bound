//
//  SavedViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import Foundation
internal import Combine

@MainActor
final class SavedViewModel: ObservableObject {
    @Published private(set) var stations: [SavedStation] = []

    private let repository: SavedStationsRepositoryProtocol

    init(repository: SavedStationsRepositoryProtocol) {
        self.repository = repository
        repository.stations
            .receive(on: DispatchQueue.main)   // subject sends from a background context
            .assign(to: &$stations)
    }

    func remove(id: String) {
        Task { await repository.remove(id: id) }
    }
}
