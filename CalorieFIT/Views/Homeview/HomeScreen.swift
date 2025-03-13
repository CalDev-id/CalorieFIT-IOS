//
//  HomeScreen.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Query private var users: [Users]
    @StateObject private var bmrViewModel = BMRViewModel()
    
    @State private var isNavigatingToImageView = false
    @State private var isPresenting = false
    @State private var uiImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary // ✅ Tambahkan ini
    
    @ObservedObject var classifier: ImageClassifier
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = users.first {
                    let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
                    
                    CalorieChartView(dailyCalorieGoal: dailyCalories, todo: {
                        isPresenting = true // Buka file picker
                    })
                    
                    .sheet(isPresented: $isPresenting) {
                        ImagePicker(
                            uiImage: $uiImage,
                            isPresenting: $isPresenting,
                            sourceType: $sourceType // ✅ Gunakan binding yang benar
                        )
                        .onDisappear {
                            if let selectedImage = uiImage {
                                classifier.detect(uiImage: selectedImage)
                                isNavigatingToImageView = true // Navigasi ke halaman berikutnya
                            }
                        }
                    }

                    NavigationLink(
                        destination: FoodDetectView(classifier: classifier, uiImage: $uiImage), // Kirim uiImage
                        isActive: $isNavigatingToImageView
                    ) {
                        EmptyView()
                    }
                    Spacer()
                    
                    
                } else {
                    Text("No user data available")
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeScreen(classifier: ImageClassifier())
}
