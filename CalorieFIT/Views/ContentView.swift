//
//  ContentView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 11/03/25.
//

//import SwiftUI
//
//struct ContentView: View {
//    @State private var capturedImage: UIImage? = nil
//
//    var body: some View {
//        TabView{
//            HomeScreen(capturedImage: $capturedImage, classifier: ImageClassifier())
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "person.circle")
//                    Text("Profile")
//                }
//            
//        }
//        .accentColor(Color.colorGreenPrimary)
//                .background(.white)
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentViews: View {
    @State private var tabSelected: Tab = .house
    @State private var capturedImage: UIImage? = nil
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TabView(selection: $tabSelected) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            getView(for: tab)
                                .tag(tab)
                        }
    //                    ForEach(Tab.allCases, id: \.rawValue) { tab in
    //                        HStack {
    //                            Image(systemName: tab.rawValue)
    //                            Text("\(tab.rawValue.capitalized)")
    //                                .bold()
    //
    //                                .animation(nil, value: tabSelected)
    //                        }
    //                        .tag(tab)
    //                    }
                    }
                }
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $tabSelected)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func getView(for tab: Tab) -> some View {
        switch tab {
        case .house:
            return AnyView(HomeScreen(capturedImage: $capturedImage, classifier: ImageClassifier()))
        case .message:
            return AnyView(ProfileView())
        case .bookmark:
            return AnyView(ProfileView())
        case .person:
            return AnyView(ProfileView())
        }
    }
}

#Preview {
    ContentViews().previewInterfaceOrientation(.portrait)
}
