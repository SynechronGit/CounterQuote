//
//  UITableviewCell+Extension.swift
//  SyneScanner
//
//  Created by Markel on 11/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

extension UITableViewCell
{
    func setBorderTocell(indexPath:IndexPath,tableView:UITableView) {
        let cornerRadius: CGFloat = 12
        self.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = self.bounds.insetBy(dx: 20, dy: 0)
        // var addLine = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.minY), tangent2End: .init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.minY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
            //    addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            //  addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(white: 1, alpha: 1).cgColor
        
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        self.backgroundView = testView

    }
    
    /**
     * Method that will add shadow effects to UITableView cells
     */
    func addShadowToCell() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowRadius = 4
    }
}
