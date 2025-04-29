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
        if let progress = progressList.first {
        ScrollView{
        VStack(alignment: .leading, spacing: 16) {
            
                HStack {
                    Spacer()
                    Text("Leveling")
                        .font(.title2)
                        .fontWeight(.medium)
                    Spacer()
                }
//                .frame(height: 50)
                .padding(.horizontal, 5)
            
                VStack(spacing: 8) {
                    HStack{
                        Text("🆙 Level: \(progress.level)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Spacer()
                        Text("🎯 XP: \(progress.xp)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }

                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 12)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.colorGreenPrimary)
                                .frame(width: CGFloat(progress.xp) / 100 * geometry.size.width, height: 12)
                                .animation(.easeInOut(duration: 0.5), value: progress.xp)
                        }
                    }
                    .frame(height: 12)
//                    HStack{
//                        Spacer()
//                        Text("🔥 Streak: \(progress.streak) hari")
//                            .font(.subheadline)
//                            .foregroundColor(.black)
//                    }
                }
                .padding(.bottom)
            

//            Divider()

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
            
            Text("🎯 Badge")
                .font(.headline)
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        ZStack{
                            Image("badge6")
                                .resizable()
                                .frame(width: 80, height: 80)
                            if progress.level < 3 {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.orangePrimary)
                                    .frame(width: 20, height: 20)
                                
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.white.opacity(0.0))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(100)
                            }
                        }
                        Text(progress.level < 3 ? "Need lvl 3" : "Badge lvl 3")
                    }
                    Spacer()
                    VStack{
                        ZStack{
                            Image("badge7")
                                .resizable()
                                .frame(width: 80, height: 80)
                            if progress.level < 10 {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.orangePrimary)
                                    .frame(width: 20, height: 20)
                                    
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.white.opacity(0.0))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(100)
                            }
                        }
                        Text(progress.level < 10 ? "Need lvl 10" : "Badge lvl 10")
                    }
                    Spacer()
                    VStack{
                        ZStack{
                            Image("badge8")
                                .resizable()
                                .frame(width: 80, height: 80)
                            if progress.level < 20 {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.orangePrimary)
                                    .frame(width: 20, height: 20)
                                
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.white.opacity(0.0))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(100)
                            }
                        }
                        Text(progress.level < 20 ? "Need lvl 20" : "Badge lvl 20")
                    }
                    Spacer()
                }
            }
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        ZStack{
                            Image("badge9")
                                .resizable()
                                .frame(width: 80, height: 80)
                            if progress.streak < 3 {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.orangePrimary)
                                    .frame(width: 20, height: 20)
                                    
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.white.opacity(0.0))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(100)
                            }
                        }
                        Text(progress.streak < 3 ? "Need Streak 3" : "Badge Str 3")
                    }
                    Spacer()
                    VStack{
                        ZStack{
                            Image("badge10")
                                .resizable()
                                .frame(width: 80, height: 80)
                            if progress.streak < 10 {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.orangePrimary)
                                    .frame(width: 20, height: 20)
                                
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.white.opacity(0.0))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(100)
                            }
                        }
                        Text(progress.streak < 10 ? "Need Streak 10" : "Badge Str 10")
                    }
                    Spacer()
                    VStack{
                        ZStack{
                            Image("badge12")
                                .resizable()
                                .frame(width: 80, height: 80)
                            if progress.streak < 20 {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.orangePrimary)
                                    .frame(width: 20, height: 20)
                                
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .foregroundColor(Color.white.opacity(0.0))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(100)
                            }
                        }
                        Text(progress.streak < 20 ? "Need Streak 20" : "Badge Str 20")
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .navigationTitle("Progress Kamu")
        .onAppear {
            viewModel.context = context // untuk memastikan context juga tersedia
            viewModel.resetDailyQuestsIfNeeded()
//            print("📆 Mengecek apakah quest perlu di-reset...")

        }
            
        }
        .scrollIndicators(.hidden)
        } else {
            Text("Belum ada data progress ditemukan.")
                .foregroundColor(.gray)
        }
    }
}
