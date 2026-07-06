//
//  cleanStationName.swift
//  LondonBound
//
//  Created by Adam Regan on 06/07/2026.
//

import Foundation

func cleanStationName(_ raw: String) -> String {
    var name = raw
    
    let suffixes = [
        " Underground Station",
        " Rail Station",
        " DLR Station",
        " Overground Station",
        " Elizabeth line Station",
        " Station"
    ]
    for suffix in suffixes {
        if name.hasSuffix(suffix) {
            name = String(name.dropLast(suffix.count))
            break
        }
    }
    
    
    return name.trimmingCharacters(in: .whitespaces)
}
