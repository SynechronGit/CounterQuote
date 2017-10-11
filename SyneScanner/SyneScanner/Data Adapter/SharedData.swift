//
//  SharedData.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import Alamofire
/**
 * Class to hold globally accessible variables
 */

class SharedData: NSObject {
    //MARK: - Properties
    public static let sharedInstance :SharedData = SharedData()
    var corelationId = UUID().uuidString
    
    var arrImage:[ImageDataModel] = []
    
    //MARK: - Initialization methods
    private override init() {
        
    }
    
    //MARK: - Update model
    func updateModel(dict:[String:AnyObject],indexNo:Int) {
         let model = SharedData.sharedInstance.arrImage[indexNo]
        
            model.imageSuccesfullyUpload = true
            model.fileUrl = dict["FileUrl"] as! String
    }
    
    //MARK: - Calculate image upload progress
    func calculateCurrentProgress() -> (progressValue : Float, uploadedImgCount: Int) {
        let totalImg:Float = Float(SharedData.sharedInstance.arrImage.count)
        let filteredArray = SharedData.sharedInstance.arrImage.filter( { (model: ImageDataModel?) -> Bool in
            return model!.imageSuccesfullyUpload == true
        })
        let uploadeImgCount:Float = Float(filteredArray.count)
        let progress:Float = uploadeImgCount/totalImg
        print("Progressss  %f,%f,%f",uploadeImgCount,totalImg,progress)
        return (progress,Int(uploadeImgCount))
        
    }
    
    //MARK: - Clear data methods
    func clearAllData() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
        SharedData.sharedInstance.arrImage.removeAll()
    }
}
