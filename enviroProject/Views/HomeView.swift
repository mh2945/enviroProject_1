import SwiftUI

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
        }
    }
}

struct DailyImpactCard: View {
    var body: some View {
        VStack {
            Text("오늘의 환경 영향")
                .font(.headline)
            
            HStack(spacing: 30) {
                ImpactStatView(title: "CO2 절감", value: "2.5kg", icon: "leaf.fill")
                ImpactStatView(title: "물 절약", value: "5L", icon: "drop.fill")
                ImpactStatView(title: "에너지 절약", value: "1.2kWh", icon: "bolt.fill")
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(15)
    }
}

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
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

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

struct GoalCard: View {
    let title: String
    let progress: Double
    let goal: String
    let current: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

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
                Text("CO2 배출량을 줄이고 건강도 챙기세요!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
} 