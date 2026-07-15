//
//  TransportModeTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct TransportModeTests {
    @Test func apiKey_elizabethIsHyphenated() {
        #expect(TransportMode.elizabeth.apiKey == "elizabeth-line")
    }

    @Test(arguments: [
        (TransportMode.tube, "tube"),
        (TransportMode.dlr, "dlr"),
        (TransportMode.overground, "overground")
    ])
    func apiKey_defaultInterpolation(mode: TransportMode, expected: String) {
        #expect(mode.apiKey == expected)
    }
}
