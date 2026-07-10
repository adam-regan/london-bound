//
//  CoreDataSavedStationsRepository.swift
//  LondonBound
//
//  Created by Adam Regan on 10/07/2026.
//

import CoreData
internal import Combine

final class CoreDataSavedStationsRepository: SavedStationsRepositoryProtocol {
    private let container: NSPersistentContainer
    private let subject: CurrentValueSubject<[SavedStation], Never>

    var stations: AnyPublisher<[SavedStation], Never> {
        subject.eraseToAnyPublisher()
    }

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
        subject = CurrentValueSubject(Self.fetch(in: container.viewContext))
    }

    func save(_ station: SavedStation) async {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        await context.perform {
            let entity = SavedStationEntity(context: context)
            entity.id = station.id
            entity.name = station.name
            entity.lat = station.lat
            entity.lon = station.lon
            entity.savedAt = station.savedAt
            try? context.save()
        }
        await refresh()
    }

    func remove(id: String) async {
        let context = container.newBackgroundContext()
        await context.perform {
            let request = SavedStationEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            let matches = (try? context.fetch(request)) ?? []
            matches.forEach(context.delete)
            try? context.save()
        }
        await refresh()
    }

    func isSaved(id: String) -> Bool {
        subject.value.contains { $0.id == id }
    }

    private func refresh() async {
        let context = container.newBackgroundContext()
        let stations = await context.perform { Self.fetch(in: context) }
        subject.send(stations)
    }

    private static func fetch(in context: NSManagedObjectContext) -> [SavedStation] {
        let request = SavedStationEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
        let results = (try? context.fetch(request)) ?? []
        
        return results.compactMap { entity in
            guard let id = entity.id, let name = entity.name, let savedAt = entity.savedAt else {
                return nil
            }
            return SavedStation(id: id, name: name, lat: entity.lat, lon: entity.lon, savedAt: savedAt)
        }
    }
}
