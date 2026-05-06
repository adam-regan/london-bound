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
                foreground: .theme.severe, background: .theme.severe
            )
        case .minor:
            ServiceConditionColor(
                foreground: .theme.minor, background: .theme.minor
            )
        case .good:
            ServiceConditionColor(
                foreground: .theme.good, background: .theme.good
            )
        case .unknown:
            ServiceConditionColor(
                foreground: Color.clear,
                background: Color.clear
            )
        }
    }
}
