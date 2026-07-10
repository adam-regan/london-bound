//
//  SavedStationsRepositoryProtocol.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

internal import Combine

protocol SavedStationsRepositoryProtocol {
    var stations: AnyPublisher<[SavedStation], Never> { get }
    func save(_ station: SavedStation) async
    func remove(id: String) async
    func isSaved(id: String) -> Bool
}
