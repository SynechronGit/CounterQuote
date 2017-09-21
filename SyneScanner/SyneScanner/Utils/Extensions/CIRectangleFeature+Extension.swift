//
//  CIRectangleFeature+Extension.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import Foundation
import CoreImage
/**
 * Extension for creating a quadrangle object from CoreImage Rectangle vertex points
 */
extension CIRectangleFeature {
    
    func makeQuadrangle() -> Quadrangle {
        return Quadrangle(topLeft: self.topLeft,
                          topRight: self.topRight,
                          bottomRight: self.bottomRight,
                          bottomLeft: self.bottomLeft)
    }
    
}

/**
 * Extension for retrieving the element with the biggest rectangle from an array
 */
extension Array where Element: CIRectangleFeature {
    
    // Find the biggest rectange feature within a list of rectange features
    // - Returns: the biggest rectange or nil if the array is empty
    func findBiggestRectangle() -> CIRectangleFeature? {
        guard self.count > 0 else {
            return nil
        }
        var halfPerimiterValue:CGFloat = 0
        var biggestRectangle: CIRectangleFeature?
        
        for rect in self {
            let p1 = rect.topLeft
            let p2 = rect.topRight
            let width = hypot(p1.x - p2.x, p1.y - p2.y)
            
            let p3 = rect.topLeft
            let p4 = rect.bottomLeft
            let height = hypot(p3.x - p4.x, p3.y - p4.y)
            
            let currentHalfPerimiterValue = height + width;
            if (halfPerimiterValue < currentHalfPerimiterValue) {
                halfPerimiterValue = currentHalfPerimiterValue
                biggestRectangle = rect
            }
        }
        
        return biggestRectangle
    }
    
}
