import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("오늘의 활동")) {
                    ActivityLogRow(activity: "걷기", value: "7,000걸음", time: "오전 9:00")
                    ActivityLogRow(activity: "재활용", value: "페트병 2개", time: "오전 11:30")
                }
                
                Section(header: Text("이번 주 통계")) {
                    StatisticRow(title: "총 걸음 수", value: "35,000걸음")
                    StatisticRow(title: "절약한 CO2", value: "12.5kg")
                    StatisticRow(title: "재활용 횟수", value: "8회")
                }
            }
            .navigationTitle("활동 기록")
        }
    }
}

struct ActivityLogRow: View {
    let activity: String
    let value: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity)
                    .font(.headline)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StatisticRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.green)
        }
    }
}

#Preview {
    ActivityView()
} 