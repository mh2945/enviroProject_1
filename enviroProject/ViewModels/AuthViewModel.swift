import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    @Published var errorMessage: String?
    
    init() {
        // 자동 로그인 체크
        checkAutoLogin()
    }
    
    func login(email: String, password: String) async throws {
        // 실제 서버 통신 로직이 들어갈 자리
        do {
            // 임시 로그인 성공 처리
            let user = User(id: UUID(), email: email, nickname: "환경 지킴이")
            await MainActor.run {
                self.user = user
                self.isAuthenticated = true
                // 자동 로그인을 위한 사용자 정보 저장
                UserDefaults.standard.set(email, forKey: "savedEmail")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "로그인에 실패했습니다."
            }
            throw error
        }
    }
    
    func signUp(email: String, password: String, nickname: String) async throws {
        // 실제 회원가입 로직 구현
        do {
            let user = User(id: UUID(), email: email, nickname: nickname)
            await MainActor.run {
                self.user = user
                self.isAuthenticated = true
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "회원가입에 실패했습니다."
            }
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        // 비밀번호 재설정 이메일 발송 로직
    }
    
    func signOut() {
        self.user = nil
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "savedEmail")
    }
    
    private func checkAutoLogin() {
        if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") {
            // 저장된 이메일이 있으면 자동 로그인 시도
            Task {
                try await login(email: savedEmail, password: "")
            }
        }
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let nickname: String
} 