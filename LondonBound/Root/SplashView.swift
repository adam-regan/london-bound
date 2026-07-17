//
//  SplashView.swift
//  LondonBound
//

import SwiftUI

struct SplashView: View {
    @State private var isVisible = false

    var body: some View {
        ZStack {
            Color.theme.background
            VStack(spacing: 20) {
                Image("LogoMark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 116, height: 116)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: CornerRadius.xl,
                            style: .continuous
                        )
                    )

                Text("London Bound")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.theme.textPrimary)
            }
            .opacity(isVisible ? 1 : 0)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { isVisible = true }
        }
    }
}

#Preview {
    SplashView()
}
