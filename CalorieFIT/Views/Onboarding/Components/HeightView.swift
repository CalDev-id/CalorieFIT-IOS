//
//  HeightView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//
//
//import SwiftUI
//import AudioToolbox
//
//struct HeightView: View {
//    @Binding var inputHeight: Double
//    let minHeight: Double = 120
//    let maxHeight: Double = 220
//    @State var offset: CGFloat = 0
//    var body: some View {
//        VStack{
//            HStack() {
//                Text("")
//                    .font(.system(size: 50, weight: .bold))
//                Text("\(getWeight())cm")
//            }
//            ZStack {
//                RulerView()
//                    .frame(height: 60)
//                    .padding(.horizontal, 20)
//
//                            // Moving Indicator
//                Rectangle()
//                    .frame(width: 4, height: 60)
//                    .foregroundColor(Color.colorGreenPrimary)
//                    .offset(x: mapValueToPosition(inputHeight))
//                }
//
//                        // Slider for height input
//                Slider(value: $inputHeight, in: minHeight...maxHeight, step: 1)
//                    .padding(.horizontal, 20)
//                    .foregroundStyle(Color.gray)
//            let pickerCount = 6
//
//            customSlider(pickerCount: pickerCount, offset: $offset){
//                HStack(spacing: 0){
//                    ForEach(1...pickerCount,id: \.self){ index in
//                        VStack{
//                            Rectangle()
//                                .fill(Color.gray)
//                                .frame(width: 1, height: 30)
//                            Text("\(30 + (index * 10))")
//                                .font(.caption2)
//                                .foregroundColor(Color.gray)
//                        }
//                        .frame(width: 20)
//                        
//                        ForEach(1...4, id: \.self){ index in
//                            Rectangle()
//                                .fill(Color.gray)
//                                .frame(width: 1, height: 15)
//                                .frame(width: 20)
//                        }
//                    }
//                    VStack{
//                        Rectangle()
//                            .fill(Color.gray)
//                            .frame(width: 1, height: 30)
//                        Text("\(100)")
//                            .font(.caption2)
//                            .foregroundColor(Color.gray)
//                    }
//                    .frame(width: 20)
//                }
//                .offset(x: (getRect().width - 30) / 2)
//                .padding(.trailing, getRect().width - 30)
//            }
//            .frame(height: 50)
//            .overlay(
//                Rectangle()
//                    .fill(Color.colorGreenPrimary)
//                    .frame(width: 4, height: 50)
//                    .offset(x: 0.8, y: -30)
//            )
//            .padding()
//            
//        }
//    }
//    private func mapValueToPosition(_ value: Double) -> CGFloat {
//        let width: CGFloat = 300 // Adjust based on screen width
//        let range = maxHeight - minHeight
//        let ratio = CGFloat((value - minHeight) / range)
//        return ratio * width - (width / 2)
//    }
//    
//    func getWeight() -> String {
//        let startHeight = 40
//        let progress = offset / 20
//        
//        return "\(startHeight + (Int(progress) * 2))"
//    }
//}
//
//func getRect()->CGRect{
//    return UIScreen.main.bounds
//}
//
//struct RulerView: View {
//    let minHeight: Double = 120
//    let maxHeight: Double = 220
//    let step: Double = 5
//
//    var body: some View {
//        GeometryReader { geometry in
//            Canvas { context, size in
//                let width = size.width
//                let height = size.height
//                let tickSpacing = width / CGFloat((maxHeight - minHeight) / step)
//
//                for i in stride(from: minHeight, through: maxHeight, by: step) {
//                    let x = (CGFloat(i - minHeight) / CGFloat(maxHeight - minHeight)) * width
//
//                    let tickHeight: CGFloat = (i.truncatingRemainder(dividingBy: 10) == 0) ? 30 : 10
//                    let tickY = height - tickHeight
//
//                    // Draw tick marks
//                    context.stroke(
//                        Path { path in
//                            path.move(to: CGPoint(x: x, y: height))
//                            path.addLine(to: CGPoint(x: x, y: tickY))
//                        },
//                        with: .color(.gray.opacity(0.5)),
//                        lineWidth: 2
//                    )
//
//                    // Draw text labels for every 10 cm
//                    if i.truncatingRemainder(dividingBy: 10) == 0 {
//                        let text = Text("\(Int(i))").font(.footnote).foregroundColor(.black)
//                        context.draw(text, at: CGPoint(x: x, y: tickY - 15))
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct customSlider<Content: View> : UIViewRepresentable {
//    var content: Content
//    
//    @Binding var offset: CGFloat
//    var pickerCount: Int
//    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content){
//        self.content = content()
//        self._offset = offset
//        self.pickerCount = pickerCount
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return customSlider.Coordinator(parent: self)
//    }
//    
//    func makeUIView(context: Context) -> UIScrollView {
//        let scrollView = UIScrollView()
//        
//        let swiftUIView = UIHostingController(rootView: content).view!
//        
//        let width = CGFloat((pickerCount * 5) * 20) + (getRect().width - 30)
//        
//        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
//        
//        scrollView.addSubview(swiftUIView)
//        scrollView.contentSize = swiftUIView.frame.size
//        scrollView.bounces = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = context.coordinator
//        return scrollView
//    }
//    
//    func updateUIView(_ uiView: UIScrollView, context: Context) {
//        
//    }
//    
//    class Coordinator: NSObject, UIScrollViewDelegate {
//        var parent : customSlider
//        
//        init(parent: customSlider) {
//            self.parent = parent
//        }
//        
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            parent.offset = scrollView.contentOffset.x
//        }
//        
//        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//            let offset = scrollView.contentOffset.x
//            
//            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
//            
//            scrollView.setContentOffset(CGPoint(x: CGFloat(value * 20), y: 0), animated: false)
//            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//            AudioServicesPlayAlertSound(1157)
//        }
//        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//            if !decelerate {
//                let offset = scrollView.contentOffset.x
//                
//                let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
//                
//                scrollView.setContentOffset(CGPoint(x: CGFloat(value * 20), y: 0), animated: false)
//                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//                AudioServicesPlayAlertSound(1157)
//            }
//        }
//    }
//}


import SwiftUI
import AudioToolbox

struct HeightView: View {
    @Binding var inputHeight: Double
    let minHeight: Double = 120
    let maxHeight: Double = 220
    @State var offset: CGFloat
    
    init(inputHeight: Binding<Double>) {
        self._inputHeight = inputHeight
        let middleValue = 50  // Target angka tengah
        let startHeight = 40
        let step = 2
        let middleOffset = CGFloat((middleValue - startHeight) / step) * 20  // Menyesuaikan offset agar tepat di angka 50
        self._offset = State(initialValue: middleOffset)
    }
    
    var body: some View {
        VStack{
            HStack() {
                Text("\(getWeight())")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                Text("cm")
                    .foregroundColor(.white)
            }
            let pickerCount = 6
            
            customSlider(pickerCount: pickerCount, offset: $offset){
                HStack(spacing: 0){
                    ForEach(1...pickerCount,id: \.self){ index in
                        VStack{
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 1, height: 30)
                            Text("\(30 + (index * 10))")
                                .font(.caption2)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 20)
                        
                        ForEach(1...4, id: \.self){ index in
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 1, height: 15)
                                .frame(width: 20)
                        }
                    }
                    VStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 1, height: 30)
                        Text("100")
                            .font(.caption2)
                            .foregroundColor(Color.gray)
                    }
                    .frame(width: 20)
                }
                .offset(x: (getRect().width - 30) / 2)
                .padding(.trailing, getRect().width - 30)
            }
            .frame(height: 50)
            
            .overlay(
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 4, height: 50)
                    .offset(x: 17, y: -30)
            )
            .padding()
        }
    }
    
    func getWeight() -> String {
        let startHeight = 40
        let step = 2
        let progress = offset / 20
        return "\(startHeight + (Int(progress) * step))"
    }
}

func getRect()->CGRect{
    return UIScreen.main.bounds
}

struct customSlider<Content: View> : UIViewRepresentable {
    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int
    
    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self._offset = offset
        self.pickerCount = pickerCount
    }
    
    func makeCoordinator() -> Coordinator {
        return customSlider.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let swiftUIView = UIHostingController(rootView: content).view!
        let width = CGFloat((pickerCount * 5) * 20) + (getRect().width - 30)
        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        
        scrollView.backgroundColor = UIColor.greenSecondary
        swiftUIView.backgroundColor = .clear
        scrollView.addSubview(swiftUIView)
        scrollView.contentSize = swiftUIView.frame.size
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        
        // Mengatur posisi awal slider di tengah berdasarkan angka 50
        let middleOffset = CGFloat((50 - 40) / 2) * 20
        scrollView.contentOffset.x = middleOffset
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent : customSlider
        init(parent: customSlider) {
            self.parent = parent
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
            scrollView.setContentOffset(CGPoint(x: CGFloat(value * 20), y: 0), animated: false)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(1157)
        }
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                let offset = scrollView.contentOffset.x
                let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
                scrollView.setContentOffset(CGPoint(x: CGFloat(value * 20), y: 0), animated: false)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(1157)
            }
        }
    }
}
