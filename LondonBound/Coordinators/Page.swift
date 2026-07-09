//
//  Page.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

enum Page: Hashable {
    case lineDetail(_ line: Line)
    case nearbyDetails(_ nearbyStation: NearbyStation)
}
