
//  WeightView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

//import SwiftUI
//
//struct WeightView: View {
//    @Binding var inputWeight: Double
//    let minWeight: Double = 40
//    let maxWeight: Double = 120
//    var body: some View {
//        VStack{
//            HStack() {
//                Text(String(inputWeight))
//                    .font(.system(size: 50, weight: .bold))
//                Text("kg")
//            }
//            ZStack {
//                RulerViewForWeight()
//                    .frame(height: 60)
//                    .padding(.horizontal, 20)
//
//                            // Moving Indicator
//                Rectangle()
//                    .frame(width: 4, height: 60)
//                    .foregroundColor(Color.colorGreenPrimary)
//                    .offset(x: mapValueToPosition(inputWeight))
//                }
//
//                        // Slider for height input
//            Slider(value: $inputWeight, in: minWeight...maxWeight, step: 1)
//                    .padding(.horizontal, 20)
//                    .foregroundStyle(Color.gray)
//            
//        }
//    }
//    private func mapValueToPosition(_ value: Double) -> CGFloat {
//        let width: CGFloat = 300 // Adjust based on screen width
//        let range = maxWeight - minWeight
//        let ratio = CGFloat((value - minWeight) / range)
//        return ratio * width - (width / 2)
//    }
//}
//
//struct RulerViewForWeight: View {
//    let minHeight: Double = 40
//    let maxHeight: Double = 120
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

import SwiftUI
import AudioToolbox

struct WeightView: View {
    @Binding var inputWeight: Double
    @State var offset: CGFloat
    
    init(inputWeight: Binding<Double>) {
        self._inputWeight = inputWeight
        let middleValue = 50
        let startHeight = 40
        let step = 2
        let middleOffset = CGFloat((middleValue - startHeight) / step) * 20
        self._offset = State(initialValue: middleOffset)
    }
    
    var body: some View {
        VStack{
            HStack() {
                Text("\(getWeight())")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                Text("kg")
                    .foregroundColor(.white)
            }
            let pickerCount = 6
            
            customSlider2(pickerCount: pickerCount, offset: $offset){
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
        .onChange(of: offset) { _ in
            inputWeight = Double(getWeight()) ?? 0
        }
    }
    
    func getWeight() -> String {
        let startHeight = 40
        let step = 2
        let progress = offset / 20
        return "\(startHeight + (Int(progress) * step))"
    }
}

struct customSlider2<Content: View> : UIViewRepresentable {
    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int
    
    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self._offset = offset
        self.pickerCount = pickerCount
    }
    
    func makeCoordinator() -> Coordinator {
        return customSlider2.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let swiftUIView = UIHostingController(rootView: content).view!
        let width = CGFloat((pickerCount * 5) * 20) + (getRect().width - 30)
        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        
//        scrollView.backgroundColor = UIColor.greenSecondary
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
        var parent : customSlider2
        init(parent: customSlider2) {
            self.parent = parent
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.offset = scrollView.contentOffset.x
            }
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
#Preview {
    OnboardingView()
}
