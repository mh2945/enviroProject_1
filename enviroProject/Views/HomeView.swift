import SwiftUI

/// 환경 지킴이 앱의 메인 홈 화면
/// - 오늘의 환경 영향도, 진행 중인 목표, 추천 활동을 표시
/// - 2024.02.26: 다크 모드 대응을 위한 색상 시스템 적용
struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 오늘의 환경 영향도
                    DailyImpactCard()
                    
                    // 현재 진행 중인 목표들
                    ActiveGoalsSection()
                    
                    // 추천 활동
                    RecommendedActivitiesSection()
                }
                .padding()
            }
            .navigationTitle("환경 지킴이")
            .background(Color(.systemBackground)) // 다크 모드 대응을 위한 시스템 배경색 적용
        }
    }
}

/// 오늘의 환경 영향을 보여주는 카드 뷰
/// - CO2 절감, 물 절약, 에너지 절약 등의 통계 표시
/// - 2024.02.26: 다크 모드 대응을 위해 배경색을 secondarySystemBackground로 변경
struct DailyImpactCard: View {
    var body: some View {
        VStack {
            Text("오늘의 환경 영향")
                .font(.headline)
                .foregroundColor(.primary) // 다크 모드 대응
            
            HStack(spacing: 30) {
                ImpactStatView(title: "CO2 절감", value: "2.5kg", icon: "leaf.fill")
                ImpactStatView(title: "물 절약", value: "5L", icon: "drop.fill")
                ImpactStatView(title: "에너지 절약", value: "1.2kWh", icon: "bolt.fill")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

/// 환경 영향 통계 항목을 표시하는 뷰
/// - 아이콘, 수치, 제목을 수직으로 배열
/// - 2024.02.26: 다크 모드 대응을 위한 텍스트 색상 수정
struct ImpactStatView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.green)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary) // 다크 모드 대응
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

/// 진행 중인 목표들을 수평 스크롤로 표시하는 섹션
/// - 걷기, 재활용, 대중교통 등의 목표 카드를 포함
struct ActiveGoalsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("진행 중인 목표")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    GoalCard(title: "걷기", progress: 0.7, goal: "10,000걸음", current: "7,000걸음")
                    GoalCard(title: "재활용", progress: 0.3, goal: "5개", current: "2개")
                    GoalCard(title: "대중교통", progress: 0.5, goal: "주 5회", current: "3회")
                }
            }
        }
    }
}

/// 개별 목표의 진행 상황을 보여주는 카드 뷰
/// - 목표 제목, 진행바, 현재/목표 수치 표시
/// - 2024.02.26: 다크 모드 대응을 위해 배경색과 텍스트 색상 수정
struct GoalCard: View {
    let title: String
    let progress: Double
    let goal: String
    let current: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary) // 다크 모드 대응
            
            ProgressView(value: progress)
                .tint(.green)
            
            HStack {
                Text(current)
                Spacer()
                Text(goal)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 150)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

/// 추천 활동 목록을 표시하는 섹션
struct RecommendedActivitiesSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("추천 활동")
                .font(.title2)
                .bold()
            
            ForEach(1...3, id: \.self) { _ in
                ActivityCard()
            }
        }
    }
}

/// 개별 추천 활동을 표시하는 카드 뷰
/// - 활동 아이콘, 제목, 설명을 포함
/// - 2024.02.26: 다크 모드 대응을 위해 배경색과 텍스트 색상 수정
struct ActivityCard: View {
    var body: some View {
        HStack {
            Image(systemName: "figure.walk")
                .font(.title)
                .foregroundColor(.green)
                .frame(width: 50)
            
            VStack(alignment: .leading) {
                Text("도보 출퇴근하기")
                    .font(.headline)
                    .foregroundColor(.primary) // 다크 모드 대응
                Text("CO2 배출량을 줄이고 건강도 챙기세요!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
} 