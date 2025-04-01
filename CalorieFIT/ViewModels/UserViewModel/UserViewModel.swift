//
//  UserViewModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData

class UserViewModel: ObservableObject {
    
    func addUserFirstTime(modelContext: ModelContext, user: Users) {
        print("Saving user data...")

        withAnimation {
            modelContext.insert(user)
            
            do {
                try modelContext.save()
                print("✅ Data berhasil disimpan!")
            } catch {
                print("❌ Error menyimpan data: \(error)")
            }
        }
    }
}

