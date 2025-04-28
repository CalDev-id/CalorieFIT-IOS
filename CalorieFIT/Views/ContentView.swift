//
//  ContentView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isPresenting: Bool = false
    @Environment(\.modelContext) var context
    @State private var isSelected: Int? = 1

    @StateObject private var GMViewModel = GamificationViewModel()

    var body: some View {
        ZStack {
            TabView {
                HomeScreen(
                    isPresenting: $isPresenting,
                    capturedImage: $capturedImage,
                    classifier: ImageClassifier()
                )
                .tabItem {
                    Image("home")
                        .background(isSelected == 1 ? Color.colorGreenPrimary : Color.black)
                }
                .onTapGesture {
                    isSelected = 1
                }

                FoodHistoryView()
                    .tabItem {
                        Image("history")
                            .background(isSelected == 2 ? Color.colorGreenPrimary : Color.black)
                    }
                    .onTapGesture {
                        isSelected = 2
                    }

                Text(" ")

                GamificationView(viewModel: GMViewModel)
                    .tabItem {
                        Image("graph")
                            .background(isSelected == 3 ? Color.colorGreenPrimary : Color.black)
                    }
                    .onTapGesture {
                        isSelected = 3
                    }

                ProfileView()
                    .tabItem {
                        Image("user")
                            .background(isSelected == 4 ? Color.colorGreenPrimary : Color.black)
                    }
                    .onTapGesture {
                        isSelected = 4
                    }
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
        }
        .onAppear {
            // Inject context setelah view muncul
            GMViewModel.context = context
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
