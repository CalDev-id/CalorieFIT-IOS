//
//  LoadingView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 03/04/25.
//

//import SwiftUI
//
//struct LoadingView: View {
//    @Binding var isSaving: Bool
//    @State private var progress: CGFloat = 0.0
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                Circle()
//                    .trim(from: 0, to: 1)
//                    .stroke(Color.gray.opacity(0.3), lineWidth: 15)
//                    .frame(width: 150, height: 150)
//                
//                Circle()
//                    .trim(from: 0, to: progress)
//                    .stroke(Color.green, style: StrokeStyle(lineWidth: 15, lineCap: .round))
//                    .frame(width: 150, height: 150)
//                    .rotationEffect(.degrees(-90))
//                
//                Text("\(Int(progress * 100))%")
//                    .font(.title)
//                    .fontWeight(.bold)
//            }
//        }
//        .onAppear {
//            Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
//                if progress < 1.0 {
//                    progress += 0.01
//                } else {
//                    timer.invalidate()
//                    isSaving = true
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    LoadingView(isSaving: .constant(false))
//}
//
