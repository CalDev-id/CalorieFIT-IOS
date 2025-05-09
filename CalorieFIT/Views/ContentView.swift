//
//  ContentView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI
import SwiftData
import Vision
//import CoreML

struct ContentView: View {
    @StateObject private var GMViewModel = GamificationViewModel()
    @StateObject private var productViewModel = FoodProductViewModel()
    @StateObject private var scanViewModel = ScanViewModel() // Tambahkan ini!

    @Environment(\.modelContext) var context
    @State private var isSelected: Int? = 1
    @State private var isPresenting: Bool = false
    @State private var isPhotoLibrary: Bool = false
    @State private var isSearchFood: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isNavigatingToImageView = false

    var body: some View {
        ZStack {
            TabView(selection: $isSelected) {
                HomeScreen()
                    .tabItem { Image(isSelected == 1 ? "Home2" : "home") }
                    .tag(1)

                FoodHistoryView()
                    .tabItem { Image(isSelected == 2 ? "history2" :"history") }
                    .tag(2)

                Text(" ") // Empty center tab
                    .hidden()
                GamificationView(viewModel: GMViewModel)
                    .tabItem { Image(isSelected == 3 ? "Chart2": "graph") }
                    .tag(3)

                ProfileView()
                    .tabItem { Image(isSelected == 4 ? "User2" :"user") }
                    .tag(4)
            }

            .accentColor(Color.colorGreenPrimary)
            .background(.white)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isPresenting = true
                    }) {
                        Image(systemName: "plus")
                            .padding(15)
                            .foregroundColor(.white)
                    }
                    .frame(width: 55, height: 55)
                    .background(Color.colorGreenPrimary)
                    .cornerRadius(100)
                    .padding(.bottom, 20)
                    Spacer()
                }
            }
            NavigationStack {
                EmptyView()
                    .navigationDestination(isPresented: $isSearchFood) {
                        FoodSearchView(isPresented: $isSearchFood, foods: productViewModel.products)
                    }
            }
        }
        .confirmationDialog("Choose an option", isPresented: $isPresenting) {
            Button("Camera") {
                sourceType = .camera
                isPhotoLibrary = true
            }
            Button("Photo Library") {
                sourceType = .photoLibrary
                isPhotoLibrary = true
            }
            Button("Search For Food") {
                isSearchFood = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $isPhotoLibrary) {
            ImagePicker(
                uiImage: $scanViewModel.capturedImage,
                isPresenting: $isPhotoLibrary,
                sourceType: $sourceType
            )
            .onDisappear {
                if scanViewModel.capturedImage != nil {
                    scanViewModel.loadImage()
                }
            }
        }
        
        .background(
            NavigationLink(
                destination: FoodDetectView(
                    capturedImage: $scanViewModel.capturedImage,
                    detectedObjects: $scanViewModel.detectedObjects,
                    showResultSheet: $scanViewModel.showResultSheet
                ),
                isActive: $scanViewModel.showResultSheet
            ) {
                EmptyView()
            }
        )
        .onAppear {
            GMViewModel.context = context
            productViewModel.loadJSON()
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    ContentView()
//}



//import SwiftUI
//
//struct ContentView: View {
//    @State private var tabSelected: Tab = .house
//    @State private var capturedImage: UIImage? = nil
//    
//    init() {
//        UITabBar.appearance().isHidden = true
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack {
//                    TabView(selection: $tabSelected) {
//                        ForEach(Tab.allCases, id: \.self) { tab in
//                            getView(for: tab)
//                                .tag(tab)
//                        }
//    //                    ForEach(Tab.allCases, id: \.rawValue) { tab in
//    //                        HStack {
//    //                            Image(systemName: tab.rawValue)
//    //                            Text("\(tab.rawValue.capitalized)")
//    //                                .bold()
//    //
//    //                                .animation(nil, value: tabSelected)
//    //                        }
//    //                        .tag(tab)
//    //                    }
//                    }
//                }
//                VStack {
//                    Spacer()
//                    CustomTabBar(selectedTab: $tabSelected)
//                }
//            }
//        }.navigationBarBackButtonHidden(true)
//    }
//    
//    func getView(for tab: Tab) -> some View {
//        switch tab {
//        case .house:
//            return AnyView(HomeScreen(capturedImage: $capturedImage, classifier: ImageClassifier()))
//        case .message:
//            return AnyView(ProfileView())
//        case .bookmark:
//            return AnyView(ProfileView())
//        case .person:
//            return AnyView(ProfileView())
//        }
//    }
//}
//
//#Preview {
//    ContentView().previewInterfaceOrientation(.portrait)
//}
