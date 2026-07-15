//
//  LossyDecodableArrayTests.swift
//  LondonBoundTests
//

@testable import LondonBound
import Testing

private struct Item: Decodable, Equatable, Sendable {
    let n: Int
}

struct LossyDecodableArrayTests {
    @Test func keepsValidElements_skipsInvalidObjects() throws {
        let json = """
        [{"n": 1}, {"bad": true}, {"n": 3}]
        """
        let result = try decodeJSON(LossyDecodableArray<Item>.self, from: json)
        #expect(result.elements == [Item(n: 1), Item(n: 3)])
    }

    @Test func skipsElementsOfWrongJSONType() throws {
        let json = """
        [{"n": 1}, "not an object", 42, {"n": 2}]
        """
        let result = try decodeJSON(LossyDecodableArray<Item>.self, from: json)
        #expect(result.elements == [Item(n: 1), Item(n: 2)])
    }

    @Test func allValid_keepsAll() throws {
        let result = try decodeJSON(LossyDecodableArray<Item>.self, from: "[{\"n\":1},{\"n\":2}]")
        #expect(result.elements == [Item(n: 1), Item(n: 2)])
    }

    @Test func allInvalid_isEmpty() throws {
        let result = try decodeJSON(LossyDecodableArray<Item>.self, from: "[{\"bad\":1},\"x\"]")
        #expect(result.elements.isEmpty)
    }

    @Test func emptyArray_isEmpty() throws {
        let result = try decodeJSON(LossyDecodableArray<Item>.self, from: "[]")
        #expect(result.elements.isEmpty)
    }
}
