//
//  CleanStationNameTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

struct CleanStationNameTests {
    @Test(arguments: [
        ("Baker Street Underground Station", "Baker Street"),
        ("Highbury & Islington Overground Station", "Highbury & Islington (Overground)"),
        ("Canary Wharf DLR Station", "Canary Wharf (DLR)"),
        ("Farringdon Elizabeth line Station", "Farringdon (Elizabeth line)"),
        ("Clapham Junction Rail Station", "Clapham Junction (Rail)"),
        ("Victoria Station", "Victoria")
    ])
    func mapsKnownSuffixes(raw: String, expected: String) {
        #expect(cleanStationName(raw) == expected)
    }

    @Test func firstMatchWins_undergroundNotBareStation() {
        // " Underground Station" is checked before the bare " Station".
        #expect(cleanStationName("Bank Underground Station") == "Bank")
    }

    @Test func caseInsensitiveSuffixMatch() {
        #expect(cleanStationName("baker street underground station") == "baker street")
    }

    @Test func noSuffix_returnedTrimmed() {
        #expect(cleanStationName("  Some Place  ") == "Some Place")
    }
}
