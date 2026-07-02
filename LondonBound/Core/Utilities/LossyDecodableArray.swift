//
//  LossyDecodableArray.swift
//  LondonBound
//
//  Created by Adam Regan on 01/07/2026.
//

import Foundation

struct LossyDecodableArray<Element: Decodable & Sendable>: nonisolated Decodable, Sendable {
    let elements: [Element]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []

        while !container.isAtEnd {
            if let element = try? container.decode(Element.self) {
                elements.append(element)
            } else {
                _ = try? container.decode(AnyCodable.self)
            }
        }

        self.elements = elements
    }
}

/// Consumes one JSON value to advance the container's index
private struct AnyCodable: Decodable {}
