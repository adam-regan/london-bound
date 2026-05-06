//
//  ServiceCondition+Color.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import SwiftUI

extension ServiceCondition {
    var color: ServiceConditionColor {
        switch self {
        case .severe:
            ServiceConditionColor(
                foreground: .theme.severe, background: .theme.severe.opacity(0.2)
            )
        case .minor:
            ServiceConditionColor(
                foreground: .theme.minor, background: .theme.minor.opacity(0.2)
            )
        case .good:
            ServiceConditionColor(
                foreground: .theme.good, background: .theme.good.opacity(0.2)
            )
        case .unknown:
            ServiceConditionColor(
                foreground: Color.clear,
                background: Color.clear
            )
        }
    }
}
