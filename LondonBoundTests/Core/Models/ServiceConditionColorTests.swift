//
//  ServiceConditionColorTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import SwiftUI
import Testing

struct ServiceConditionColorTests {
    @Test func unknownCondition_usesClearColors() {
        let color = ServiceCondition.unknown.color
        #expect(color.foreground == .clear)
        #expect(color.background == .clear)
    }

    @Test(arguments: [ServiceCondition.good, .minor, .severe])
    func knownConditions_useNonClearColors(condition: ServiceCondition) {
        #expect(condition.color.foreground != .clear)
        #expect(condition.color.background != .clear)
    }
}
