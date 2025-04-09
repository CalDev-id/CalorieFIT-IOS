//
//  ProfileView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [Users]
    @StateObject private var bmrViewModel = BMRViewModel()
    
    var body: some View {
        if let user = users.first {
        VStack {
//            if let user = users.first { // Gunakan user pertama jika tersedia
//                Text("Name: \(user.inputName)")
//                Text("Age: \(user.inputAge)")
//                Text("Gender: \(user.selectedGender)")
//                Text("Height: \(user.inputHeight, specifier: "%.1f") cm")
//                Text("Weight: \(user.inputWeight, specifier: "%.1f") kg")
//                
//                // **Gunakan ViewModel dengan mengirim data user**
//                let bmr = bmrViewModel.calculateBMR(user: user)
//                let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
//                let weightCategory = bmrViewModel.determineWeightCategory(user: user)
//                
//                Text("BMR: \(bmr, specifier: "%.1f") kcal")
//                Text("Daily Calories: \(dailyCalories, specifier: "%.1f") kcal")
//                
//                Text("Weight Category: \(weightCategory)")
//                    .fontWeight(.bold)
//                    .foregroundColor(.blue)
//            } else {
//                Text("No user data available")
//            }
            
                
            
            VStack{
                HStack {
                    Button(action: {
                        print("ayam")
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                            .padding(10)
                            .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Profile")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button(action: {
                        // Tambahkan aksi untuk trailing button di sini
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .padding(13)
                            .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                            .foregroundColor(.black)
                    }
                }
                .frame(height: 50)
                .background(.white)
//                .padding(.top, 55)
                .padding(.horizontal, 20)
                
            }
            .background(.white)
            
            Image("profile")
                .resizable()
                .frame(width: 80, height: 80)
            
            Text("\(user.inputName)")
            
            VStack{
                ProfileMenu(image: "profile_menu_1", name: "Daily Intake", toDo: {})
                ProfileMenu(image: "profile_menu_2", name: "My Meals", toDo: {})
                ProfileMenu(image: "profile_menu_3", name: "Nutrition Report", toDo: {})
                ProfileMenu(image: "profile_menu_4", name: "Favorites Food", toDo: {})
            }
            Spacer()
        }
        .padding()
        .foregroundColor(Color.black)
        }
    }
}

#Preview {
    ProfileView()
}

struct ProfileMenu: View {
    @State var image: String
    @State var name: String
    @State var toDo: () -> Void
    
    var body: some View {
        Button(action: {toDo()}){
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.trailing)
                Text(name)
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 20))
            }
        }
    }
}
