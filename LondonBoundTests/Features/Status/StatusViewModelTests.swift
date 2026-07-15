//
//  StatusViewModelTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

@MainActor
struct StatusViewModelTests {
    // MARK: - sortLines (pure)

    @Test func sortLines_ordersByModeThenName() {
        let vm = StatusViewModel(tflAPIService: TFLAPIServiceMock())
        let lines = [
            makeLine(id: .dlr, name: "DLR", mode: "dlr"),
            makeLine(id: .central, name: "Central", mode: "tube"),
            makeLine(id: .bakerloo, name: "Bakerloo", mode: "tube"),
            makeLine(id: .elizabeth, name: "Elizabeth", mode: "elizabeth-line")
        ]

        let sorted = vm.sortLines(lines)

        #expect(sorted.map(\.name) == ["Bakerloo", "Central", "DLR", "Elizabeth"])
    }

    @Test func sortLines_unknownModeSortsLast() {
        let vm = StatusViewModel(tflAPIService: TFLAPIServiceMock())
        let lines = [
            makeLine(id: .liberty, name: "Bus", mode: "bus"),
            makeLine(id: .central, name: "Central", mode: "tube")
        ]

        let sorted = vm.sortLines(lines)

        #expect(sorted.map(\.name) == ["Central", "Bus"])
    }

    // MARK: - getWorstLineStatus (pure)

    @Test func getWorstLineStatus_returnsStatusMatchingOverallCondition() {
        let vm = StatusViewModel(tflAPIService: TFLAPIServiceMock())
        // severity 10 -> good, severity 6 -> severe. overallCondition == .severe.
        let line = makeLine(name: "Central", severities: [10, 6])

        let worst = vm.getWorstLineStatus(line: line)

        #expect(worst?.statusSeverity.value == 6)
    }

    @Test func getWorstLineStatus_allGood_returnsAGoodStatus() {
        let vm = StatusViewModel(tflAPIService: TFLAPIServiceMock())
        let line = makeLine(name: "Central", severities: [10, 18])

        let worst = vm.getWorstLineStatus(line: line)

        #expect(worst?.statusSeverity.condition == .good)
    }

    // MARK: - fetch + grouping

    @Test func fetchStatuses_partitionsGoodAndDisrupted() async throws {
        let api = TFLAPIServiceMock()
        api.lineStatusResult = .success([
            makeLine(id: .district, name: "District", mode: "tube", severities: [6]),
            makeLine(id: .central, name: "Central", mode: "tube", severities: [10])
        ])
        let vm = StatusViewModel(tflAPIService: api)

        vm.startPolling()
        defer { vm.stopPolling() }
        try await waitUntil { if case .loaded = vm.statuses { return true }; return false }

        let grouped = try #require(vm.statuses.value)
        #expect(grouped.goodService.map(\.name) == ["Central"])
        #expect(grouped.disruptions.map(\.name) == ["District"])
    }

    @Test func fetchStatuses_apiError_setsErrorState() async throws {
        let api = TFLAPIServiceMock()
        api.lineStatusResult = .failure(TFLError.notFound)
        let vm = StatusViewModel(tflAPIService: api)

        vm.startPolling()
        defer { vm.stopPolling() }
        try await waitUntil { if case .error = vm.statuses { return true }; return false }
    }
}
