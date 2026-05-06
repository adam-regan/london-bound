//
//  OverallStatus.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

struct OverallStatus: Decodable, Sendable {
    let value: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Int.self)
    }
    
    init(value: Int) {
        self.value = value
    }
   
}
