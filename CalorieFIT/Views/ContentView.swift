//
//  ContentView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isPresenting: Bool = false

    var body: some View {
        ZStack {
            TabView{
                HomeScreen(isPresenting: $isPresenting, capturedImage: $capturedImage, classifier: ImageClassifier())
                    .tabItem {
                        Image("home")
                    }
                ProfileView()
                    .tabItem {
                        Image("history")
                    }
                Button(action: {
                    // Call the closure when the button is pressed
                }){
                    Image(systemName: "house")
                    Text("Home")
                }
                ProfileView()
                    .tabItem {
                        Image("graph")
                    }
                ProfileView()
                    .tabItem {
                        Image("user")
                        
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
                            .foregroundColor(Color.white)
                            
                    }
                    .frame(width: 55, height: 55)
                    .background(Color.colorGreenPrimary)
                    .cornerRadius(100)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}



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
