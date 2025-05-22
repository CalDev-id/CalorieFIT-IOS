//
//  CalorieFITApp.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

//import SwiftUI
//import SwiftData
//
//@main
//struct CalorieFITApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Users.self,
//            DailyNutrition.self,
//            FoodHistory.self,
//            UserProgress.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentViewWrapper()
//                .modelContainer(sharedModelContainer)
//        }
//    }
//}
//struct ContentViewWrapper: View {
//    @Query private var users: [Users]
//
//    var body: some View {
//        NavigationStack {
//            if users.isEmpty {
//                OnboardingView()
//            } else {
//                ContentView()
//            }
//        }
//        .preferredColorScheme(.light)
//    }
//}


import SwiftUI
import SwiftData

@main
struct CalorieFITApp: App {
    var sharedModelContainer: ModelContainer?

    init() {
        let schema = Schema([
            Users.self,
            DailyNutrition.self,
            FoodHistory.self,
            UserProgress.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("❌ Gagal membuat ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if let container = sharedModelContainer {
                ContentViewWrapper()
                    .modelContainer(container)
            } else {
                ErrorView()
            }
        }
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

struct ErrorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            Text("Terjadi kesalahan saat memuat aplikasi.")
                .font(.headline)
            Text("Silakan tutup dan buka kembali aplikasi.")
                .font(.subheadline)
        }
        .padding()
    }
}
struct ContentViewWrapper: View {
    @Environment(\.modelContext) private var context
    @State private var hasUsers: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if hasUsers {
                    ContentView()
                } else {
                    OnboardingView()
                }
            }
        }
        .task {
            let fetchDescriptor = FetchDescriptor<Users>()
            if let result = try? context.fetch(fetchDescriptor) {
                hasUsers = !result.isEmpty
            }
        }
        .preferredColorScheme(.light)
    }
}
