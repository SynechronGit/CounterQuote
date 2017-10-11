//
//  UIButton+Extension.swift
//  SyneScanner
//
//  Created by Markel on 07/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

extension UIButton {
    /**
     * Method that will add border style to buttons
     */
    func setBorderToButton() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 22
        self.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
    }
}
