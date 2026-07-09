//
//  StatusViewModel.swift
//  LondonBound
//
//  Created by Adam Regan on 03/05/2026.
//

import Foundation
internal import Combine

@MainActor
final class StatusViewModel: ObservableObject {
    @Published var statuses: Loadable<GroupedStatuses> = .loading
    @Published var timeUpdated: String?

    private let apiService: TFLAPIServiceProtocol
    private lazy var poller = Poller { [weak self] in self?.fetchStatuses() }

    init(tflAPIService: TFLAPIServiceProtocol) {
        apiService = tflAPIService
    }

    func startPolling() {
        poller.start()
    }

    func stopPolling() {
        poller.stop()
    }

    func getWorstLineStatus(line: Line) -> LineStatus? {
        return line.lineStatuses
            .first {
                $0.statusSeverity.condition == line.overallCondition
            }
    }

    private func fetchStatuses() {
        Task {
            do {
                let response = try await apiService.fetchLineStatus()
                let grouped = GroupedStatuses(
                    goodService: sortLines(response
                        .filter {
                            $0.lineStatuses
                                .allSatisfy {
                                    $0.statusSeverity.condition == .good
                                }
                        }),
                    disruptions: sortLines(response
                        .filter {
                            $0.lineStatuses
                                .contains { $0.statusSeverity.condition != .good }
                        })
                )
                statuses =
                    .loaded(grouped)

                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "H:mm"
                timeUpdated = formatter.string(from: now)

            } catch {
                statuses = .error(error)
            }
        }
    }

    func sortLines(_ lines: [Line]) -> [Line] {
        let modeOrder: [String] = [
            TransportMode.tube.apiKey,
            TransportMode.overground.apiKey,
            TransportMode.dlr.apiKey,
            TransportMode.elizabeth.apiKey
        ]
        return lines.sorted {
            let lhsIndex = modeOrder.firstIndex(of: $0.modeName) ?? .max
            let rhsIndex = modeOrder.firstIndex(of: $1.modeName) ?? .max
            return (lhsIndex, $0.name) < (rhsIndex, $1.name)
        }
    }
}
