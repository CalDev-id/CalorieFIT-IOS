//
//  CalorieFITApp.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI
import SwiftData

@main
struct CalorieFITApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Users.self,
            DailyNutrition.self,
            FoodHistory.self,
            UserProgress.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentViewWrapper()
                .modelContainer(sharedModelContainer)
        }
    }
}
struct ContentViewWrapper: View {
    @Query private var users: [Users]

    var body: some View {
        NavigationStack {
            if users.isEmpty {
                OnboardingView()
            } else {
                ContentView()
            }
        }
        .preferredColorScheme(.light)
    }
}

//struct ContentViewWrapper: View {
//    @Environment(\.modelContext) private var context
//    @State private var users: [Users] = []
//
//    var body: some View {
//        NavigationStack {
//            Group {
//                if users.isEmpty {
//                    OnboardingView()
//                } else {
//                    ContentView()
//                }
//            }
//            .onAppear {
//                fetchUsers()
//            }
//        }
//        .preferredColorScheme(.light)
//    }
//
//    private func fetchUsers() {
//        let descriptor = FetchDescriptor<Users>()
//        do {
//            users = try context.fetch(descriptor)
//        } catch {
//            print("Failed to fetch users: \(error)")
//        }
//    }
//}

