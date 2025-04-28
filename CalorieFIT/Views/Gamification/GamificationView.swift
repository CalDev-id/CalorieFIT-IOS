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
    @ObservedObject var viewModel: GamificationViewModel
    @Environment(\.modelContext) var context
    
    

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
            let images = ["quest1", "quest2", "quest3"]
            ForEach(viewModel.dailyQuests.indices, id: \.self) { index in
                let quest = viewModel.dailyQuests[index]
                let imageName = images[index % images.count]

                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text(quest.name)
                    
                    Spacer()
                    
                    Image(systemName: quest.isCompleted ? "checkmark.seal" : "checkmark.seal")
                        .padding(10)
                        .background(quest.isCompleted ? Color.green : Color.red)
                        .clipShape(Circle()) // Apply rounded corners to the checkmark
                        .foregroundColor(.white) // Ensure the checkmark icon stands out
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(quest.isCompleted ? Color.green.opacity(0.2) : Color.red.opacity(0.2)) // Light background color to make the border stand out
                .cornerRadius(10) // Apply to the whole HStack
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Apply the border after corner radius
                        .stroke(quest.isCompleted ? Color.green : Color.red, lineWidth: 1.5) // Draw the border after rounding
                )
            }
            
//            VStack{
//                HStack{
//                    VStack{
//                        ZStack{
//                            RunningAppleView()
//                            Image("locked")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .background(.gray.opacity(0.2))
//                        }
//                        Text("Unlock lvl 3")
//                    }
//                    VStack{
//                        ZStack{
//                            RunningAppleView()
//                            Image("locked")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .background(.gray.opacity(0.2))
//                        }
//                        Text("Unlock lvl 3")
//                    }
//                    VStack{
//                        ZStack{
//                            RunningAppleView()
//                            Image("locked")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .background(.gray.opacity(0.2))
//                        }
//                        Text("Unlock lvl 3")
//                    }
//                }
//                HStack{
//                    VStack{
//                        ZStack{
//                            RunningAppleView()
//                            Image("locked")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .background(.gray.opacity(0.2))
//                        }
//                        Text("Unlock lvl 3")
//                    }
//                    VStack{
//                        ZStack{
//                            RunningAppleView()
//                            Image("locked")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .background(.gray.opacity(0.2))
//                        }
//                        Text("Unlock lvl 3")
//                    }
//                    VStack{
//                        ZStack{
//                            RunningAppleView()
//                            Image("locked")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .background(.gray.opacity(0.2))
//                        }
//                        Text("Unlock lvl 3")
//                    }
//                }
//            }



            Spacer()
        }
        .padding()
        .navigationTitle("Progress Kamu")
        .onAppear {
            viewModel.context = context // untuk memastikan context juga tersedia
            viewModel.resetDailyQuestsIfNeeded()
            print("📆 Mengecek apakah quest perlu di-reset...")

        }
    }
}

struct RunningAppleView: View {
    @State private var currentImage = 1
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        Image("apple_run_\(currentImage)")
            .resizable()
            .frame(width: 100, height: 100)
            .onReceive(timer) { _ in
                // Ganti image dari 1 ke 2 dan sebaliknya
                currentImage = currentImage == 1 ? 2 : 1
            }
    }
}
