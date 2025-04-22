//
//  ImageBase64Converter.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 21/04/25.
//

import Foundation
import UIKit

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
            guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
                return nil
            }
            return UIImage(data: imageData)
        }
}


extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self) {
            return UIImage(data: data)
        }
        return nil
    }
}
