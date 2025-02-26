import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showResetPassword = false
    @State private var isLoading = false
    
    // 입력 값 유효성 검사
    private var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private var isValidPassword: Bool {
        return password.count >= 6
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // 로고 및 환영 메시지
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("환경 지킴이")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("함께 만드는 지속 가능한 미래")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 50)
                    
                    // 로그인 폼
                    VStack(spacing: 20) {
                        TextField("이메일", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .overlay(
                                !email.isEmpty && !isValidEmail ?
                                Text("올바른 이메일 형식이 아닙니다")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.top, 40)
                                : nil
                            )
                        
                        SecureField("비밀번호", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                !password.isEmpty && !isValidPassword ?
                                Text("비밀번호는 6자 이상이어야 합니다")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.top, 40)
                                : nil
                            )
                        
                        Button("비밀번호를 잊으셨나요?") {
                            showResetPassword = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Button(action: performLogin) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("로그인")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidForm ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!isValidForm || isLoading)
                    }
                    .padding(.horizontal)
                    
                    // 소셜 로그인 옵션
                    VStack(spacing: 15) {
                        Text("또는")
                            .foregroundColor(.secondary)
                        
                        SocialLoginButton(title: "Apple로 계속하기", image: "apple.logo", action: appleSocialLogin)
                        SocialLoginButton(title: "Google로 계속하기", image: "g.circle.fill", action: googleSocialLogin)
                    }
                    
                    // 회원가입 링크
                    Button(action: { showSignUp = true }) {
                        Text("계정이 없으신가요? ")
                            .foregroundColor(.secondary) +
                        Text("회원가입")
                            .foregroundColor(.green)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .alert("오류", isPresented: .constant(authViewModel.errorMessage != nil)) {
                Button("확인") {
                    authViewModel.errorMessage = nil
                }
            } message: {
                Text(authViewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $showResetPassword) {
                PasswordResetView(authViewModel: authViewModel)
            }
        }
    }
    
    private var isValidForm: Bool {
        isValidEmail && isValidPassword
    }
    
    private func performLogin() {
        isLoading = true
        Task {
            do {
                try await authViewModel.login(email: email, password: password)
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
    
    private func appleSocialLogin() {
        // Apple 로그인 구현
    }
    
    private func googleSocialLogin() {
        // Google 로그인 구현
    }
}

struct SocialLoginButton: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: image)
                    .font(.title3)
                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nickname = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("기본 정보") {
                    TextField("이메일", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    TextField("닉네임", text: $nickname)
                    
                    SecureField("비밀번호", text: $password)
                    SecureField("비밀번호 확인", text: $confirmPassword)
                }
                
                Section {
                    Button("가입하기") {
                        // 회원가입 로직 구현
                        dismiss()
                    }
                }
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PasswordResetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("비밀번호 재설정")) {
                    TextField("이메일", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    Button("재설정 링크 발송") {
                        Task {
                            do {
                                try await authViewModel.resetPassword(email: email)
                                alertMessage = "비밀번호 재설정 링크가 발송되었습니다."
                                showAlert = true
                            } catch {
                                alertMessage = "오류가 발생했습니다. 다시 시도해주세요."
                                showAlert = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("비밀번호 재설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("확인") {
                    if alertMessage.contains("발송되었습니다") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
} 