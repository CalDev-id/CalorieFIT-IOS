//
//  HomeScreen.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftUI
import SwiftData
import Vision
import CoreML

struct HomeScreen: View {
    @Query private var users: [Users]
    @StateObject private var bmrViewModel = BMRViewModel()
    @Binding var isPresenting: Bool
    @State private var isImagePickerPresented: Bool = false
    @State private var isPhotoLibrary: Bool = false
    @State private var isSearchFood: Bool = false
    @StateObject var productViewModel = FoodProductViewModel()

    
    @State private var detectedObjects: [DetectedObject] = []
    @State private var showResultSheet: Bool = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @Binding var capturedImage: UIImage?
    @ObservedObject var classifier: ImageClassifier
    @State private var isNavigatingToImageView = false
    
    @StateObject var viewModel = NutritionViewModel()
    @State private var model: VNCoreMLModel? = nil

//    let model: Caloryfy_8700? = {
//        do {
//            return try Caloryfy_8700(configuration: MLModelConfiguration())
//        } catch {
//            print("Error loading model: \(error)")
//            return nil
//        }
//    }()

    var body: some View {
        ScrollView{
            VStack {
                if let user = users.first {
                    let dailyCalories = bmrViewModel.calculateDailyCalories(user: user)
                    
                    CalorieChartView(dailyCalorieGoal: dailyCalories)
                                        
                    NutritionChartView()
                        .offset(y: -70)
                    .confirmationDialog("Choose an option", isPresented: $isPresenting, titleVisibility: .visible) {
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
                    .sheet(isPresented: $isSearchFood){
                        FoodSearchView(isPresented: $isSearchFood,
                                       foods: productViewModel.products)
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
            .onAppear {
                productViewModel.loadJSON()
            }
        }
    }
    
    func loadImage() {
        if model == nil {
            loadModel()
        }

        guard let model = model else {
            print("Model tidak tersedia!")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            detectedObjects = results.map { result in
                DetectedObject(
                    label: result.labels.first?.identifier ?? "",
                    confidence: result.labels.first?.confidence ?? 0.0,
                    boundingBox: result.boundingBox
                )
            }
        }

        guard let image = capturedImage,
              let pixelBuffer = convertToCVPixelBuffer(newImage: image) else {
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
    
    func loadModel() {
        do {
            let mlModel = try Caloryfy_8700(configuration: MLModelConfiguration()).model
            model = try VNCoreMLModel(for: mlModel)
        } catch {
            print("Error loading CoreML model: \(error)")
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
