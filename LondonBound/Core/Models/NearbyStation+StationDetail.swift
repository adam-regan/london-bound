//
//  NearbyStation+StationDetail.swift
//  LondonBound
//
//  Created by Adam Regan on 13/07/2026.
//

extension NearbyStation {
    var detail: StationDetail {
        StationDetail(id: id, name: name, lat: lat, lon: lon)
    }
}
