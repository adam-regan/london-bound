//
//  RootContainerView.swift
//  LondonBound
//
//  Created by Adam Regan on 16/07/2026.
//

import SwiftUI

struct RootContainerView: View {
    let dependencies: AppDependencies
    @State private var isFinished = false

    var body: some View {
        ZStack {
            RootView(dependencies: dependencies)
            if !isFinished {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeOut(duration: 0.15)) { isFinished = true }
        }
    }
}
