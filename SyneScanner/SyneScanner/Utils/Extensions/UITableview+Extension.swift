//
//  UITableview+Extension.swift
//  SyneScanner
//
//  Created by Markel on 11/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit


extension UITableView
{
    func addShadow() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowRadius = 4     
    }
}
