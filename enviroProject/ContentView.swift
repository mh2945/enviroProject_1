//
//  ContentView.swift
//  enviroProject
//
//  Created by ikjang on 2/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
            
            ActivityView()
                .tabItem {
                    Label("활동", systemImage: "figure.walk")
                }
            
            ProfileView()
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
