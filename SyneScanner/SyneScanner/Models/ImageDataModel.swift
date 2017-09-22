//
//  ImageDataModel.swift
//  SyneScanner
//
//  Created by Markel on 21/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ImageDataModel: NSObject {

    var image:UIImage?
    var progress:Float = 0
    var fileUrl = ""
    lazy var correlationId = UUID().uuidString
}
