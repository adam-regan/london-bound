//
//  Color.swift
//  LondonBound
//
//  Created by Adam Regan on 29/04/2026.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // MARK: - App Colors

    let accent = Color("Accent")
    let background = Color("Background")
    let primary = Color("Primary")
    let secondary = Color("Secondary")
    let surface = Color("Surface")
    let textPrimary = Color("TextPrimary")
    let textSecondary = Color("TextSecondary")

    // MARK: - Line Status

    let good = Color("Good")
    let minor = Color("Minor")
    let severe = Color("Severe")

    // MARK: - Line Colors

    let bakerloo = Color("Bakerloo")
    let central = Color("Central")
    let circle = Color("Circle")
    let district = Color("District")
    let elizabeth = Color("Elizabeth")
    let hammersmithAndCity = Color("HammersmithAndCity")
    let jubilee = Color("Jubilee")
    let metropolitan = Color("Metropolitan")
    let northern = Color("Northern")
    let piccadilly = Color("Piccadilly")
    let victoria = Color("Victoria")
    let waterlooAndCity = Color("WaterlooAndCity")
    let dlr = Color("DLR")
    let overground = Color("Overground")
    let trams = Color("Trams")
    let emiratesCableCar = Color("EmiratesCableCar")
}
