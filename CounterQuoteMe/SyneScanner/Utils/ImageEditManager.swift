//
//  ImageEditManager.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import Foundation
import UIKit

/** 
 * ImageEditManager utilises the Quadrangle object to get a UIImage object
 */
class ImageEditManager {
    // Class function to cut a UIImage object from a Quadrangle object and Data that the circumfrence occupies
    class func cut(quadrangle: Quadrangle, outOfImageWith imageData: Data,
                   completion: @escaping (UIImage?)->Void) {
        DispatchQueue.global().async {
            var uiImage: UIImage? = nil
            let rawImage = CIImage(data: imageData)
            if let ciImage = correctPerspective(for: rawImage, with: quadrangle) {
                uiImage = makeUIImageFromCIImage(ciImage)
            }
            DispatchQueue.main.async {
                completion(uiImage)
            }
        }
    }
    
    // MARK: Image Edit Class functions
    
    // Class function to get UIImage from CIImage object
    private class func makeUIImageFromCIImage(_ ciImage: CIImage) -> UIImage? {
        let size = CGSize(width: ciImage.extent.height, height: ciImage.extent.width)
        _ = UIGraphicsBeginImageContext(size)
        UIImage(ciImage: ciImage, scale: 1.0, orientation: UIImageOrientation.right).draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let uiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return uiImage
    }
    
    // Class function to get CIImage from Quadrangle vertices
    private class func correctPerspective(for image: CIImage?,
                                          with quadrangle: Quadrangle) -> CIImage? {
        let rectangleCoordinates = ["inputTopLeft":CIVector(cgPoint: quadrangle.topLeft),
                                    "inputTopRight":CIVector(cgPoint: quadrangle.topRight),
                                    "inputBottomLeft":CIVector(cgPoint: quadrangle.bottomLeft),
                                    "inputBottomRight":CIVector(cgPoint: quadrangle.bottomRight)]
        return image?.applyingFilter("CIPerspectiveCorrection", parameters: rectangleCoordinates)
    }
    
}
