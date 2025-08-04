//
//  ContentView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 03/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem { Label("Home", systemImage: "house.fill") }
                
                SearchView()
                    .tag(1)
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                
                FavoritesView()
                    .tag(2)
                    .tabItem { Label("Profile", systemImage: "person.fill") }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default bar
            
            // Custom Tab Bar
            HStack {
                TabButton(icon: "house", index: 0, selectedTab: $selectedTab)
                Spacer()
                TabButton(icon: "magnifyingglass", index: 1, selectedTab: $selectedTab)
                Spacer()
                TabButton(icon: "square.and.arrow.down.fill", index: 2, selectedTab: $selectedTab)
            }
            .padding(.horizontal,40)
            .padding(.vertical,20)
            .background(
                // Black blur with opacity
                BlurView(style: .systemMaterialDark)
                    .background(Color.black.opacity(0.1))
            )
            
        }
        .ignoresSafeArea(.all)
    }
}

struct TabButton: View {
    var icon: String
    var index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            selectedTab = index
        } label: {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(selectedTab == index ? .white : .gray)
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
}
