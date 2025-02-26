//
//  enviroProjectApp.swift
//  enviroProject
//
//  Created by ikjang on 2/26/25.
//

import SwiftUI

/// 환경 지킴이 앱의 메인 앱 구조체
/// - 앱의 진입점 및 전역 상태 관리
/// - 2024.02.26: 화면 전환 애니메이션 추가
@main
struct enviroProjectApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    ContentView()
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    LoginView()
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut, value: authViewModel.isAuthenticated)  // 화면 전환 애니메이션
            .environmentObject(authViewModel)  // 앱 전역에서 인증 상태 공유
        }
    }
}
