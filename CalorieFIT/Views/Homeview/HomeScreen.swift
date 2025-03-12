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
    
    var body: some View {
        if users.isEmpty {
            Text("No data available")
        } else {
            VStack{
                ForEach(users) { user in
                    Text("Name: \(user.inputName)")
                    Text("Age: \(String(user.inputAge))")
                    Text("Gender: \(user.selectedGender)")
                    Text("Height: \(String(user.inputHeight))")
                    Text("Weight: \(String(user.inputWeight))")
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
