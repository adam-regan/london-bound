//
//  SeverityLevel.swift
//  LondonBound
//
//  Created by Adam Regan on 05/05/2026.
//

struct SeverityLevel: Decodable, Sendable, Hashable {
    let value: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Int.self)
    }

    init(value: Int) {
        self.value = value
    }

    var description: String {
        switch value {
        case 0: return "Special Service"
        case 1: return "Closed"
        case 2: return "Suspended"
        case 3: return "Part Suspended"
        case 4: return "Planned Closure"
        case 5: return "Part Closure"
        case 6: return "Severe Delays"
        case 7: return "Reduced Service"
        case 8: return "Bus Service"
        case 9: return "Minor Delays"
        case 10: return "Good Service"
        case 11: return "Part Closed"
        case 12: return "Exit Only"
        case 13: return "No Step Free Access"
        case 14: return "Change of frequency"
        case 15: return "Diverted"
        case 16: return "Not Running"
        case 17: return "Issues Reported"
        case 18: return "No Issues"
        case 19: return "Information"
        case 20: return "Service Closed"
        default: return "Unknown"
        }
    }

    var condition: ServiceCondition {
        switch value {
        case 0, 1, 2, 3, 4, 5, 6, 7, 8, 11, 15, 16, 20:
            .severe
        case 9, 17, 14, 12:
            .minor
        case 10, 18, 19, 13:
            .good
        default:
            .unknown
        }
    }
}
