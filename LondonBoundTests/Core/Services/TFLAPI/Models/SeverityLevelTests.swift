//
//  SeverityLevelTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct SeverityLevelTests {
    @Test(arguments: [
        (0, ServiceCondition.severe),
        (6, ServiceCondition.severe),
        (16, ServiceCondition.severe),
        (20, ServiceCondition.severe),
        (9, ServiceCondition.minor),
        (12, ServiceCondition.minor),
        (14, ServiceCondition.minor),
        (10, ServiceCondition.good),
        (13, ServiceCondition.good),
        (19, ServiceCondition.good),
        (99, ServiceCondition.unknown)
    ])
    func condition(value: Int, expected: ServiceCondition) {
        #expect(SeverityLevel(value: value).condition == expected)
    }

    @Test(arguments: [
        (10, "Good Service"),
        (6, "Severe Delays"),
        (1, "Closed"),
        (999, "Unknown")
    ])
    func description(value: Int, expected: String) {
        #expect(SeverityLevel(value: value).description == expected)
    }

    @Test func decodesFromBareInt() throws {
        let level = try decodeJSON(SeverityLevel.self, from: "7")
        #expect(level.value == 7)
    }
}
