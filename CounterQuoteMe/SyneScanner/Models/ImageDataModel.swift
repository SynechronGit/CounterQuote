//
//  ImageDataModel.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

// Data model with properties of each scanned image
class ImageDataModel: NSObject {

    var image:UIImage?
    var progress:Float = 0
    var fileUrl = ""
    var imageSuccesfullyUpload = false
    var isDeleted = false
    var isUploadingInProgress = false

}
