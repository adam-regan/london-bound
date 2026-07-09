//
//  Poller.swift
//  LondonBound
//
//  Created by Adam Regan on 09/07/2026.
//

import Foundation

@MainActor
final class Poller {
    private var task: Task<Void, Never>?
    private let interval: UInt64
    private let action: @MainActor () -> Void

    init(interval: TimeInterval = 60, action: @MainActor @escaping () -> Void) {
        self.interval = UInt64(interval * 1_000_000_000)
        self.action = action
    }

    func start() {
        task?.cancel()

        task = Task { [weak self] in
            while !Task.isCancelled {
                self?.action()
                do {
                    try await Task.sleep(nanoseconds: self?.interval ?? 0)
                } catch {
                    break
                }
            }
        }
    }

    func stop() {
        task?.cancel()
    }
}
