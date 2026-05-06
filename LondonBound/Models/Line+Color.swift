//
//  Line+Color.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

extension Line {
    var color: Color {
        switch id {
        case "bakerloo": return .theme.bakerloo
        case "central": return .theme.central
        case "circle": return .theme.circle
        case "district": return .theme.district
        case "dlr": return .theme.dlr
        case "elizabeth": return .theme.elizabeth
        case "hammersmith-city": return .theme.hammersmithAndCity
        case "jubilee": return .theme.jubilee
        case "metropolitan": return .theme.metropolitan
        case "northern": return .theme.northern
        case "piccadilly": return .theme.piccadilly
        case "victoria": return .theme.victoria
        case "waterloo-city": return .theme.waterlooAndCity
        default: return .theme.overground
        }
    }
}
