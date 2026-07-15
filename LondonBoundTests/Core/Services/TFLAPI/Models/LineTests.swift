//
//  LineTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct LineTests {
    @Test func overallCondition_severeTakesPrecedence() {
        // 10 -> good, 9 -> minor, 6 -> severe
        #expect(makeLine(severities: [10, 9, 6]).overallCondition == .severe)
    }

    @Test func overallCondition_minorWhenNoSevere() {
        #expect(makeLine(severities: [10, 9]).overallCondition == .minor)
    }

    @Test func overallCondition_goodWhenAllGood() {
        #expect(makeLine(severities: [10, 18]).overallCondition == .good)
    }

    @Test func overallCondition_emptyStatuses_isGood() {
        #expect(makeLine(severities: []).overallCondition == .good)
    }
}
