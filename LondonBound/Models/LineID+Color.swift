//
//  LineID+Color.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

extension LineID {
    var color: Color {
        switch self {
        case .bakerloo: return .theme.bakerloo
        case .central: return .theme.central
        case .circle: return .theme.circle
        case .district: return .theme.district
        case .dlr: return .theme.dlr
        case .elizabeth: return .theme.elizabeth
        case .hammersmithCity: return .theme.hammersmithAndCity
        case .jubilee: return .theme.jubilee
        case .metropolitan: return .theme.metropolitan
        case .northern: return .theme.northern
        case .piccadilly: return .theme.piccadilly
        case .victoria: return .theme.victoria
        case .waterlooCity: return .theme.waterlooAndCity
        case .liberty, .lioness, .mildmay, .suffragette, .weaver, .windrush:
            return .theme.overground
        }
    }
}
