//
//  GamificationView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//

import SwiftUI
import SwiftData

struct GamificationView: View {
    @Query var progressList: [UserProgress]
    @StateObject var viewModel: GamificationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let progress = progressList.first {
                Text("🎯 XP: \(progress.xp)")
                ProgressView(value: Double(progress.xp), total: 100)
                Text("🆙 Level: \(progress.level)")
                Text("🔥 Streak: \(progress.streak) hari")
            } else {
                Text("Belum ada data progress ditemukan.")
                    .foregroundColor(.gray)
            }

            Divider()

            Text("🎯 Daily Quests")
                .font(.headline)

            ForEach(viewModel.dailyQuests) { quest in
                HStack {
                    Text(quest.name)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(quest.isCompleted ? .green : .red)
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Progress Kamu")
    }
}
