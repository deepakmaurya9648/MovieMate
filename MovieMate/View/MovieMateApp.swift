//
//  MovieMateApp.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import SwiftUI

@main
struct MovieMateApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesManager)
        }
    }
}
