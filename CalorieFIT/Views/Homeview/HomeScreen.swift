//
//  HomeScreen.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

//import SwiftUI
//import SwiftData
//
//struct HomeScreen: View {
//    @Query private var users: [Users]
//    @StateObject private var bmrViewModel = BMRViewModel()
//    
//    @State private var isNavigatingToImageView = false
//    @State private var isPresenting = false
//    @State private var isImagePickerPresented = false
//    @State private var uiImage: UIImage?
//    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    
//    @ObservedObject var classifier: ImageClassifier
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if let user = users.first {
//                    let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
//                    
//                    CalorieChartView(dailyCalorieGoal: dailyCalories)
//                    
//                    Button(action: {
//                        isPresenting = true
//                    }) {
//                        Text("+ Track eat")
//                            .fontWeight(.bold)
//                            .frame(width: 200, height: 45)
//                            .background(Color.colorGreenPrimary)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .actionSheet(isPresented: $isPresenting) {
//                        ActionSheet(
//                            title: Text("Take a photo or select from library"),
//                            message: Text(""),
//                            buttons: [
//                                .default(Text("Camera"), action: {
//                                    sourceType = .camera
//                                    isImagePickerPresented = true
//                                }),
//                                .default(Text("Photo Library"), action: {
//                                    sourceType = .photoLibrary
//                                    isImagePickerPresented = true
//                                }),
//                                .cancel()
//                            ]
//                        )
//                    }
//                    .sheet(isPresented: $isImagePickerPresented) {
//                        ImagePicker(
//                            uiImage: $uiImage,
//                            isPresenting: $isImagePickerPresented,
//                            sourceType: $sourceType
//                        )
//                        .onDisappear {
//                            if let selectedImage = uiImage {
//                                classifier.detect(uiImage: selectedImage)
//                                isNavigatingToImageView = true
//                            }
//                        }
//                    }
//
//                    NavigationLink(
//                        destination: FoodDetectView(classifier: classifier, uiImage: $uiImage),
//                        isActive: $isNavigatingToImageView
//                    ) {
//                        EmptyView()
//                    }
//                    Spacer()
//                    
//                } else {
//                    Text("No user data available")
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    HomeScreen(classifier: ImageClassifier())
//}


import SwiftUI
import SwiftData
import Vision
import CoreML

struct HomeScreen: View {
    @Query private var users: [Users]
    @StateObject private var bmrViewModel = BMRViewModel()
    @State private var isPresenting: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var isPhotoLibrary: Bool = false
    
    @State private var detectedObjects: [DetectedObject] = []
    @State private var showResultSheet: Bool = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @Binding var capturedImage: UIImage?
    @ObservedObject var classifier: ImageClassifier
    @State private var isNavigatingToImageView = false
    
    @StateObject var viewModel = NutritionViewModel()

//    let cameraService = CameraService()
    
    // Safely loading ML Model
    let model: Caloryfy_8700? = {
        do {
            return try Caloryfy_8700(configuration: MLModelConfiguration())
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }()

    var body: some View {
        ScrollView{
            VStack {
                if let user = users.first {
                    let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
                    
                    CalorieChartView(dailyCalorieGoal: dailyCalories)
                    
                    Button(action: { isPresenting = true }) {
                        Text("+ Track eat")
                            .fontWeight(.bold)
                            .frame(width: 200, height: 45)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .confirmationDialog("Choose an option", isPresented: $isPresenting, titleVisibility: .visible) {
                        //                        Button("Camera") { isImagePickerPresented = true }
                        Button("Camera") {
                            sourceType = .camera
                            isPhotoLibrary = true
                        }
                        Button("Photo Library") {
                            sourceType = .photoLibrary
                            isPhotoLibrary = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .sheet(isPresented: $isPhotoLibrary) {
                        ImagePicker(
                            uiImage: $capturedImage,
                            isPresenting: $isPhotoLibrary,
                            sourceType: $sourceType
                        )
                        .onDisappear {
                            if let selectedImage = capturedImage {
                                loadImage()
                                isNavigatingToImageView = true
                            }
                        }
                    }
                    
                    NavigationLink(
                        destination: FoodDetectView(
                            capturedImage: $capturedImage,
                            detectedObjects: $detectedObjects,
                            showResultSheet: $showResultSheet
                        ),
                        isActive: $isNavigatingToImageView
                    ) {
                        EmptyView()
                    }
                }
            }
            .onChange(of: capturedImage) { newImage in
                if newImage != nil {
                    isNavigatingToImageView = true
                }
            }
        }
        .background(.thinMaterial)
    }
    
    func loadImage() {
        guard let model = model else {
            print("Model tidak ditemukan!")
            return
        }
        let mlModel = model.model

        guard let vnCoreMLModel = try? VNCoreMLModel(for: mlModel) else {
            print("Gagal membuat VNCoreMLModel")
            return
        }

        let request = VNCoreMLRequest(model: vnCoreMLModel) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            detectedObjects = results.map { result in
                DetectedObject(
                    label: result.labels.first?.identifier ?? "",
                    confidence: result.labels.first?.confidence ?? 0.0,
                    boundingBox: result.boundingBox
                )
            }
        }

        guard let image = capturedImage, let pixelBuffer = convertToCVPixelBuffer(newImage: image) else {
            print("Gagal mengonversi gambar ke pixel buffer")
            return
        }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        do {
            try requestHandler.perform([request])
            print("Deteksi gambar berhasil, berpindah ke FoodDetectView")
            showResultSheet.toggle()
        } catch {
            print("Error processing image: \(error.localizedDescription)")
        }
    }
}

struct DetectedObject {
    let label: String
    let confidence: VNConfidence
    let boundingBox: CGRect
}

func convertToCVPixelBuffer(newImage: UIImage) -> CVPixelBuffer? {
    let width = Int(newImage.size.width)
    let height = Int(newImage.size.height)
    var pixelBuffer: CVPixelBuffer?

    let attrs = [kCVPixelBufferCGImageCompatibilityKey: true,
                 kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary
    
    guard CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer) == kCVReturnSuccess,
          let buffer = pixelBuffer else {
        return nil
    }

    CVPixelBufferLockBaseAddress(buffer, .readOnly)
    
    if let context = CGContext(
        data: CVPixelBufferGetBaseAddress(buffer),
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) {

        context.draw(newImage.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
    }

    CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
    return buffer
}

//#Preview {
//    HomeScreen(capturedImage: .constant(nil), classifier: ImageClassifier())
//}
