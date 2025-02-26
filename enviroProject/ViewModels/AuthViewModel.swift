import SwiftUI

/// 사용자 인증 및 상태 관리를 위한 ViewModel
/// - 로그인, 회원가입, 로그아웃 등의 인증 관련 기능 처리
/// - 2024.02.26: 마스터 계정 및 자동 로그인 기능 추가
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    @Published var errorMessage: String?
    
    // 마스터 계정 정보 (테스트용)
    private let masterEmail = "admin"
    private let masterPassword = "0000"
    
    init() {
        checkAutoLogin()
    }
    
    /// 로그인 처리 함수
    /// - Parameters:
    ///   - email: 사용자 이메일
    ///   - password: 사용자 비밀번호
    ///   - enableAutoLogin: 자동 로그인 활성화 여부
    /// - 2024.02.26: 자동 로그인 옵션 추가
    func login(email: String, password: String, enableAutoLogin: Bool = false) async throws {
        // 마스터 계정 확인
        if email == masterEmail && password == masterPassword {
            let user = User(id: UUID(), email: email, nickname: "관리자")
            await MainActor.run {
                self.user = user
                self.isAuthenticated = true
                // 자동 로그인이 체크된 경우에만 저장
                if enableAutoLogin {
                    UserDefaults.standard.set(email, forKey: "savedEmail")
                    UserDefaults.standard.set(true, forKey: "autoLoginEnabled")
                }
            }
            return
        }
        
        // 마스터 계정이 아닌 경우 로그인 실패
        await MainActor.run {
            self.errorMessage = "로그인에 실패했습니다."
        }
        throw AuthError.invalidCredentials
    }
    
    // 에러 타입 정의
    enum AuthError: Error {
        case invalidCredentials
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
    
    /// 로그아웃 처리 함수
    /// - 사용자 정보 초기화 및 자동 로그인 설정 제거
    /// - 2024.02.26: 자동 로그인 정보 삭제 기능 추가
    func signOut() {
        self.user = nil
        self.isAuthenticated = false
        // 로그아웃 시 자동 로그인 정보 삭제
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        UserDefaults.standard.removeObject(forKey: "autoLoginEnabled")
    }
    
    /// 자동 로그인 체크 함수
    /// - UserDefaults에 저장된 로그인 정보 확인
    /// - 2024.02.26: 자동 로그인 활성화 여부 확인 로직 추가
    private func checkAutoLogin() {
        // 자동 로그인이 활성화되어 있는 경우에만 시도
        if UserDefaults.standard.bool(forKey: "autoLoginEnabled"),
           let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") {
            Task {
                try? await login(email: savedEmail, password: masterPassword)
            }
        }
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let nickname: String
} 
