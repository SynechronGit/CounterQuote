//
//  SettingsBundleHelper.swift
//  SyneScanner
//
//  Created by Kartik on 16/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class SettingsBundleHelper: NSObject {
    struct SettingsBundleKeys {
        static let DemoVersionKey = "demo_preference"
        static let MultipleCarriersVersionKey = "carriers_preference"
        static let ProducerCodeKey = "producer_preference"
        static let LineOfBusinessKey = "business_preference"
    }
    
    class func setVersionAndBuildNumber() {
        UserDefaults.standard.set(true, forKey: "demo_preference")
        UserDefaults.standard.set(true, forKey: "carriers_preference")
    }
}
