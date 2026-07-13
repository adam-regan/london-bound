//
//  SavedStation+StationDetail.swift
//  LondonBound
//
//  Created by Adam Regan on 13/07/2026.
//

import Foundation

extension SavedStation {
    var detail: StationDetail {
        StationDetail(id: id, name: name, lat: lat, lon: lon)
    }

    init(_ detail: StationDetail, savedAt: Date = .now) {
        self.init(
            id: detail.id,
            name: detail.name,
            lat: detail.lat,
            lon: detail.lon,
            savedAt: savedAt
        )
    }
}
