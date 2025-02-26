//
//  enviroProjectApp.swift
//  enviroProject
//
//  Created by ikjang on 2/26/25.
//

import SwiftUI

@main
struct enviroProjectApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}
