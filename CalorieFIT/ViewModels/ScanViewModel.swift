//
//  ScanViewModel.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 29/04/25.
//

import SwiftUI
import Vision
import CoreML
import SwiftData
import UIKit

struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: VNConfidence
    let boundingBox: CGRect
}


class ScanViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var detectedObjects: [DetectedObject] = []
    @Published var model: VNCoreMLModel?
    @Published var showResultSheet = false

    init() {
        loadModel()
    }
    
    private func loadModel() {
        do {
            let mlModel = try Caloryfy_8700(configuration: MLModelConfiguration()).model
            self.model = try VNCoreMLModel(for: mlModel)
            print("ML Model loaded successfully")
        } catch {
            print("Error loading model: \(error)")
        }
    }

    func loadImage() {
        guard let model = model else {
            print("Model tidak tersedia")
            return
        }
        
        guard let image = capturedImage,
              let pixelBuffer = convertToCVPixelBuffer(newImage: image) else {
            print("Gagal mengonversi gambar ke pixel buffer")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            self.detectedObjects = results.map { result in
                DetectedObject(
                    label: result.labels.first?.identifier ?? "",
                    confidence: result.labels.first?.confidence ?? 0.0,
                    boundingBox: result.boundingBox
                )
            }
            DispatchQueue.main.async {
                self.showResultSheet.toggle()
            }
        }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error processing image: \(error.localizedDescription)")
        }
    }
    
    func convertToCVPixelBuffer(newImage: UIImage) -> CVPixelBuffer? {
        let width = Int(newImage.size.width)
        let height = Int(newImage.size.height)
        
        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let unwrappedPixelBuffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(unwrappedPixelBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedPixelBuffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }
        
        UIGraphicsPushContext(context)
        newImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return unwrappedPixelBuffer
    }

}
