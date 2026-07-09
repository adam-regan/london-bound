//
//  MainCoordinator.swift
//  LondonBound
//
//  Created by Adam Regan on 06/05/2026.
//

import Foundation
internal import Combine
import SwiftUI

class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    var tflAPIService: TFLAPIServiceProtocol?

    init(tflAPIService: TFLAPIServiceProtocol? = nil) {
        self.tflAPIService = tflAPIService
    }

    func push(_ page: Page) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .lineDetail(let line):
            LineDetailView(line: line)
        case .nearbyDetails(let nearby):
            if let api = tflAPIService {
                NearbyDetailView(station: nearby, tflAPIService: api)
            }
        }
    }
}
