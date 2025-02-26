import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading) {
                            Text("환경 지킴이")
                                .font(.title2)
                            Text("Level 5")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical)
                }
                
                Section("업적") {
                    AchievementRow(title: "첫 걸음", description: "첫 환경 활동 완료", completed: true)
                    AchievementRow(title: "꾸준한 발걸음", description: "30일 연속 목표 달성", completed: false)
                }
                
                Section("설정") {
                    NavigationLink("알림 설정") {
                        Text("알림 설정")
                    }
                    NavigationLink("목표 관리") {
                        Text("목표 관리")
                    }
                    NavigationLink("연동된 기기") {
                        Text("연동된 기기")
                    }
                }
            }
            .navigationTitle("프로필")
        }
    }
}

struct AchievementRow: View {
    let title: String
    let description: String
    let completed: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

#Preview {
    ProfileView()
} 