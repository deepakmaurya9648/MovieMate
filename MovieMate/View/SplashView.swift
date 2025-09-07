//
//  SplashView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 21/08/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Image(systemName: "movieclapper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .padding(.bottom,24)
                Text("Movie Mate").font(.system(size: 40, weight: .bold)).fontWeight(.bold).foregroundColor(.white)
            }
        }
    }
}

#Preview {
    SplashView()
}
