//
//  MovieMateApp.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import SwiftUI

@main
struct MovieMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var favoritesManager = FavoritesManager()
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash{
                SplashView().onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            }else{
                ContentView()
                    .environmentObject(favoritesManager)
            }
            
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationDelegate = NotificationDelegate()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
        NotificationManager.shared.requestNotificationPermission()
        return true
    }
}
