//
//  LineID.swift
//  LondonBound
//
//  Created by Adam Regan on 01/07/2026.
//

enum LineID: String, Codable, Sendable, Hashable, CaseIterable {
    case bakerloo
    case central
    case circle
    case district
    case dlr
    case elizabeth
    case hammersmithCity = "hammersmith-city"
    case jubilee
    case metropolitan
    case northern
    case piccadilly
    case victoria
    case waterlooCity = "waterloo-city"
    case liberty
    case lioness
    case mildmay
    case suffragette
    case weaver
    case windrush
}
