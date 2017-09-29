//
//  ImagePreviewCollectionViewCell.swift
//  SyneScanner
//
//  Created by Markel on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
class ImagePreviewCollectionViewCell: UICollectionViewCell {
    var retakeDelegate : ImageShareAndRetakeDelegate?
    @IBOutlet weak var imagePreview: UIImageView!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBAction func deleteOptionTapped(_ sender: Any) {
        retakeDelegate?.deleteImageAt(cell: self)
    }
    
    @IBAction func retakeImageTapped(_ sender: Any) {
        retakeDelegate?.retakeImageAt(cell: self)
    }
    
}

protocol ImageShareAndRetakeDelegate {
    func retakeImageAt(cell : UICollectionViewCell)
    func deleteImageAt(cell : UICollectionViewCell)
}
