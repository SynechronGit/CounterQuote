//
//  Quadrangle.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import Foundation
import QuartzCore

// The quadrangle with four vertices
struct Quadrangle {
    
    //  a zero size quadrangle
    static let zero = Quadrangle(topLeft: .zero,
                                 topRight: .zero,
                                 bottomRight: .zero,
                                 bottomLeft: .zero)
    
    //  The top left vertex
    var topLeft: CGPoint
    
    //  The top right vertex
    var topRight: CGPoint
    
    //  The bottom left vertex
    var bottomLeft: CGPoint
    
    //  The bottom right vertex
    var bottomRight: CGPoint
    
    init(topLeft: CGPoint,
         topRight: CGPoint,
         bottomRight: CGPoint,
         bottomLeft: CGPoint){
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    
    /// Apply the transform to all its vertices
    /// - parameter transform: the transform to be applied
    mutating func applying(_ transform: CGAffineTransform) {
        self.topLeft = self.topLeft.applying(transform)
        self.topRight = self.topRight.applying(transform)
        self.bottomRight = self.bottomRight.applying(transform)
        self.bottomLeft = self.bottomLeft.applying(transform)
    }
    
    /// Check if the quadrangle has any vertices that equal to zero
    /// - returns: true if the quadrangle doesn't have any vertex that equals to zero, otherwise false
    func isValid() -> Bool{
        return !(self.topLeft.equalTo(.zero) ||
            self.topRight.equalTo(.zero) ||
            self.bottomLeft.equalTo(.zero) ||
            self.bottomRight.equalTo(.zero))
    }
}
