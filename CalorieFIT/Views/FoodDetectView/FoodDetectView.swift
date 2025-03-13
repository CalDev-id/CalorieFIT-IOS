//
//  FoodDetectView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 13/03/25.
//

import SwiftUI

struct FoodDetectView: View {
    @ObservedObject var classifier: ImageClassifier
    @Binding var uiImage: UIImage?
    @State private var isPresenting = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            Group {
                if uiImage != nil {
                    Image(uiImage: uiImage!)
                        .resizable()
//                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 600)
                        .ignoresSafeArea()
                }
            }
            
            VStack {
                Group {
                    if let imageClass = classifier.imageClass {
                        VStack{
                            HStack {
                                Text(imageClass)
                                    .bold()
                                    .font(.title)
                                
                                Text("490 Cals")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color.colorGreenPrimary)
                            HStack{
                                Text("60 g  Carbs")
                                Text("40 g  Protein")
                                Text("10 g  Fat")
                            }
                            .padding(5)
                            .foregroundColor(.gray)
                            PrimaryBTN(name: "Confirm", todo: {})
                        }
                    } else {
                        HStack {
                            Text("Image categories: NA")
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isPresenting) {
            ImagePicker(uiImage: $uiImage, isPresenting: $isPresenting, sourceType: $sourceType)
                .onDisappear {
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }
        }
    }
}

//#Preview {
//    FoodDetectView(classifier: ImageClassifier())
//}
