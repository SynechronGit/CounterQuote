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
        model.imageSuccesfullyUpload = true
        model.fileUrl = dict["FileUrl"] as! String
    }
    
    func calculateCurrentProgress() -> Float
    {
        let totalImg:Float = Float(SharedData.sharedInstance.arrImage.count)
        let filteredArray = SharedData.sharedInstance.arrImage.filter( { (model: ImageDataModel) -> Bool in
            return model.imageSuccesfullyUpload == true
        })
        let uploadeImgCount:Float = Float(filteredArray.count)
        let progress:Float = uploadeImgCount/totalImg
        print("Progressss  %f,%f,%f",uploadeImgCount,totalImg,progress)
        return progress
        
        
    }
}
