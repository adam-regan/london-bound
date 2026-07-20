//
//  SavedStationsRepositoryStub.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

#if DEBUG
internal import Combine

nonisolated struct SavedStationsRepositoryStub: SavedStationsRepositoryProtocol {
    private let subject: CurrentValueSubject<[SavedStation], Never>

    init(stations: [SavedStation] = []) {
        subject = CurrentValueSubject(stations)
    }

    var stations: AnyPublisher<[SavedStation], Never> {
        subject.eraseToAnyPublisher()
    }

    func save(_ station: SavedStation) async {
        guard !subject.value.contains(where: { $0.id == station.id }) else { return }
        subject.send(subject.value + [station])
    }

    func remove(id: String) async {
        subject.send(subject.value.filter { $0.id != id })
    }

    func isSaved(id: String) -> Bool {
        subject.value.contains { $0.id == id }
    }
}
#endif
