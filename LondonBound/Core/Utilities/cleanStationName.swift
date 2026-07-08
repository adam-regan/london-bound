//
//  cleanStationName.swift
//  LondonBound
//
//  Created by Adam Regan on 06/07/2026.
//

import Foundation

func cleanStationName(_ raw: String) -> String {
    var name = raw

    let replacements: [(suffix: String, replacement: String)] = [
        (" Underground Station", ""),
        (" Overground Station", " (Overground)"),
        (" DLR Station", " (DLR)"),
        (" Elizabeth line Station", " (Elizabeth line)"),
        (" Rail Station", " (Rail)"),
        (" Station", "")
    ]
    for pair in replacements {
        if name.hasSuffix(pair.suffix) {
            name = String(name.dropLast(pair.suffix.count)) + pair.replacement
            break
        }
    }

    return name.trimmingCharacters(in: .whitespaces)
}
