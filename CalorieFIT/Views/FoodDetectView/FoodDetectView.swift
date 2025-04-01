//
//  FoodDetectView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 13/03/25.
//

//import SwiftUI
//
//struct FoodDetectView: View {
//    @ObservedObject var classifier: ImageClassifier
//    @Binding var uiImage: UIImage?
//    @State private var isPresenting = false
//    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    
//    
//    var body: some View {
//        VStack {
//            Group {
//                if uiImage != nil {
//                    Image(uiImage: uiImage!)
//                        .resizable()
////                        .scaledToFit()
//                        .frame(width: UIScreen.main.bounds.width, height: 600)
//                        .ignoresSafeArea()
//                }
//            }
//            
//            VStack {
//                Group {
//                    if let imageClass = classifier.imageClass {
//                        VStack{
//                            HStack {
//                                Text(imageClass)
//                                    .bold()
//                                    .font(.title)
//                                
//                                Text("490 Cals")
//                                    .font(.title3)
//                                    .fontWeight(.semibold)
//                            }
//                            .foregroundColor(Color.colorGreenPrimary)
//                            HStack{
//                                Text("60 g  Carbs")
//                                Text("40 g  Protein")
//                                Text("10 g  Fat")
//                            }
//                            .padding(5)
//                            .foregroundColor(.gray)
//                            PrimaryBTN(name: "Confirm", todo: {})
//                        }
//                    } else {
//                        HStack {
//                            Text("Image categories: NA")
//                                .font(.caption)
//                        }
//                    }
//                }
//                .padding()
//            }
//            Spacer()
//        }
//        .edgesIgnoringSafeArea(.all)
////        .sheet(isPresented: $isPresenting) {
////            ImagePicker(uiImage: $uiImage, isPresenting: $isPresenting, sourceType: $sourceType)
////                .onDisappear {
////                    if uiImage != nil {
////                        classifier.detect(uiImage: uiImage!)
////                    }
////                }
////        }
//    }
//}

//#Preview {
//    FoodDetectView(classifier: ImageClassifier())
//}




import SwiftUI
import Vision

struct FoodDetectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var capturedImage: UIImage?
    @Binding var detectedObjects: [DetectedObject]
    @Binding var showResultSheet: Bool
    @StateObject var viewModel = NutritionViewModel()
    
    @Environment(\.modelContext) private var modelContext
    private var nutritionManager: NutritionDataManager {
        NutritionDataManager(context: modelContext)
    }

    var mostAccurateObject: DetectedObject? {
        return detectedObjects.max(by: { $0.confidence < $1.confidence })
    }

    var matchedNutrition: NutritionModel? {
        if let bestObject = mostAccurateObject {
            return viewModel.nutrition.first { $0.food_name.lowercased() == bestObject.label.lowercased() }
        }
        return nil
    }


    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 600)
                    .ignoresSafeArea()
                    .overlay {
                        GeometryReader { geometry in
                            if let bestObject = mostAccurateObject {
                                Path { path in
                                    path.addRect(VNImageRectForNormalizedRect(bestObject.boundingBox, Int(geometry.size.width), Int(geometry.size.height)))
                                }
                                .stroke(Color.red, lineWidth: 2)
                            }
                        }
                    }
            }

            VStack {
                if let bestObject = mostAccurateObject {
                    VStack(spacing: 10) {
                        HStack {
                            Text(bestObject.label.capitalized)
                                .bold()
                                .font(.title)

                            if let matched = matchedNutrition {
                                Text("\(String(format: "%.0f", matched.calory ?? 0)) Cals") // Format tanpa angka desimal
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        .foregroundColor(Color.colorGreenPrimary)

                        if let matched = matchedNutrition {
                            HStack {
                                Text("\(String(format: "%.1f", matched.carbohydrate ?? 0)) g Carbs") // Satu angka di belakang koma
                                Text("\(String(format: "%.1f", matched.protein ?? 0)) g Protein")
                                Text("\(String(format: "%.1f", matched.fat ?? 0)) g Fat")
                            }
                            .padding(5)
                            .foregroundColor(.gray)
                        } else {
                            Text("Nutrition data not found.")
                                .foregroundColor(.gray)
                        }

                        PrimaryBTN(name: "Confirm") {
                            if let matched = matchedNutrition {
                                nutritionManager.updateOrInsertNutrition(
                                    calory: matched.calory ?? 0,
                                    protein: matched.protein ?? 0,
                                    fat: matched.fat ?? 0,
                                    carbohydrate: matched.carbohydrate ?? 0
                                )
                            }
                            dismiss()
                        }
                    }
                } else {
                    VStack {
                        Text("Nothing could be detected.")
                        Button("Try again!") {
                            capturedImage = nil
                            detectedObjects = []
                            showResultSheet.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }

            Spacer()
        }
        .onAppear {
            viewModel.loadJSON()
        }

        .edgesIgnoringSafeArea(.all)
    }
}
