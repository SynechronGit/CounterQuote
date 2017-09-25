//
//  SharedData.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

/**
 * Class to hold globally accessible variables
 */

class SharedData: NSObject {
    public static let sharedInstance :SharedData = SharedData()
    var corelationId = UUID().uuidString
    private override init() {
        
    }
    var arrImage:[ImageDataModel] = []
    
    func updateModel(dict:[String:AnyObject],indexNo:Int)
    {
        let model = SharedData.sharedInstance.arrImage[indexNo]
        model.fileUrl = dict["FileUrl"] as! String
    }
}
