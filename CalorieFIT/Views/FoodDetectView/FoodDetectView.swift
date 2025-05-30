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
import SwiftData

struct FoodDetectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var capturedImage: UIImage?
    @Binding var detectedObjects: [DetectedObject]
    @Binding var showResultSheet: Bool
    @StateObject var viewModel = NutritionViewModel()
    @State private var navigateToContentView = false

//    @EnvironmentObject var gamificationVM: GamificationViewModel

    //graph
    @Query private var users: [Users]
    @Query private var dailyNutritions: [DailyNutrition]
    @State private var proteinConsumed: Double = 0
    @State private var fatConsumed: Double = 0
    @State private var carbsConsumed: Double = 0
    
    var proteinGoal: Double {
        guard let user = users.first else { return 0 }
        return BMRViewModel().determineMacronutrients(user: user).protein
    }
    
    var fatGoal: Double {
        guard let user = users.first else { return 0 }
        return BMRViewModel().determineMacronutrients(user: user).fat
    }
    
    var carbsGoal: Double {
        guard let user = users.first else { return 0 }
        return BMRViewModel().determineMacronutrients(user: user).carbs
    }
    
    var proteinProgress: Double {
        min(proteinConsumed / proteinGoal, 1.0)
    }
    
    var fatProgress: Double {
        min(fatConsumed / fatGoal, 1.0)
    }
    
    var carbsProgress: Double {
        min(carbsConsumed / carbsGoal, 1.0)
    }
    
    @Environment(\.modelContext) private var modelContext
    private var nutritionManager: NutritionDataManager {
        NutritionDataManager(context: modelContext)
    }
    private var GMViewModel: GamificationViewModel {
        GamificationViewModel(context: modelContext)
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

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            if let bestObject = mostAccurateObject {
                if let image = capturedImage {
                    VStack{
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20))
                                    .padding(10)
                                    .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Text("Nutrition")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: {
                                // Tambahkan aksi untuk trailing button di sini
                            }) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 20))
                                    .padding(13)
                                    .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(height: 50)
                        .background(.white)
                        .padding(.top, 55)
                        .padding(.horizontal, 20)
                        
                        Image(uiImage: image)
                            .resizable()
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
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                        
                        Spacer()
                    }
                    .background(.white)
                }
                VStack{
                    Spacer()
                    
                    VStack{
                        HStack{
                            Text(bestObject.label.capitalized)
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                            Spacer()
                            Text("1 Pcs")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 25)
                        //                        .padding(.top, 20)
                        HStack {
                            Text("Nutrition Value")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            Spacer()
                            if let matched = matchedNutrition {
                                Text("\(String(format: "%.0f", matched.calory ?? 0)) Cals")
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 25)
                        
                        if let matched = matchedNutrition {
                            VStack{
                                //disini cuy
                                MacronutrientDetailView(image: "protein3", name: "Protein", contain: (matched.protein ?? 0), goal: proteinGoal, color: Color.green)
                                MacronutrientDetailView(image: "carbs2", name: "Carbs", contain: (matched.carbohydrate ?? 0), goal: carbsGoal, color: Color.yellow)
                                MacronutrientDetailView(image: "fat2", name: "Fat", contain: (matched.fat ?? 0), goal: fatGoal, color: Color.orange)
                            }
                            
                        } else {
                            Text("Nutrition data not found.")
                                .foregroundColor(.gray)
                        }
                        
                        HStack{
                            Text("Source of food data : ")
                            Link("www.fatsecret.co.id", destination: URL(string: "https://www.fatsecret.co.id/kalori-gizi/")!)
                                        .foregroundColor(.blue)
                        }
                        
                        SecondaryBTN(name: "Confirm", color: Color.colorGreenPrimary) {
                            if let matched = matchedNutrition {
                                nutritionManager.updateOrInsertNutrition(
                                    food_name: matched.food_name,
                                    calory: matched.calory ?? 0,
                                    protein: matched.protein ?? 0,
                                    fat: matched.fat ?? 0,
                                    carbohydrate: matched.carbohydrate ?? 0,
                                    image: capturedImage,
                                    imageURL: nil
                                )
                                if let update = matchedNutrition {
                                    GMViewModel.updateProgress(food_name: matched.food_name, calory: matched.calory ?? 0, protein: matched.protein ?? 0, fat: matched.fat ?? 0, carbohydrate: matched.carbohydrate ?? 0)
                                }
                            }
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .background(.white)
                    .clipShape(RoundedCorners(radius: 30, corners: [.topLeft, .topRight]))
                }
                .frame(maxWidth: .infinity)
            }else {
                // ELSE condition: Tidak ada objek yang terdeteksi
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .padding(10)
                                .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Nutrition")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button(action: {
                            // Optional: action for trailing button
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .padding(13)
                                .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(height: 50)
                    .background(.white)
                    .padding(.top, 55)
                    .padding(.horizontal, 20)

//                    if let image = capturedImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: UIScreen.main.bounds.width, height: 400)
//                    }
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
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
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                    }
//                    Spacer()

                    Spacer()
                    


                }
                .background(.white)
                
                VStack{
                    Spacer()
                    
                    VStack{
                        VStack(spacing: 15) {
                            Text("Nothing could be detected.")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .fontWeight(.medium)
                            
    //                        SecondaryBTN(name: "Back", color: Color.colorGreenPrimary) {
    //                            dismiss()
    //                        }
                        }
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 200)
//                        .background(.white)
//                        .clipShape(RoundedCorners(radius: 30, corners: [.topLeft, .topRight]))
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .background(.white)
                        .clipShape(RoundedCorners(radius: 30, corners: [.topLeft, .topRight]))
                    }
                }
            }
            

        }
        .onAppear {
            viewModel.loadJSON()
        }
    
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
    }
}


struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MacronutrientDetailView: View {
    let image: String
    let name: String
    let contain: Double
    let goal: Double
    let color: Color
    
    var progress: Double {
        min(contain / goal, 1.0)
    }
    
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.2)
                .frame(height: 65)
            VStack{
                HStack{
                    Text(name)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.1f", contain))g")
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 12))
                }
                //graph
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 265, height: 4)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                        .frame(width: CGFloat(progress) * 265, height: 4)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.trailing, 25)
        .padding(.leading, 10)
        .frame(maxWidth: .infinity)
    }
}
