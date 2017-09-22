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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var retakeButton: UIBarButtonItem!
    @IBAction func shareImageOptionsTapped(_ sender: Any) {
        retakeDelegate?.shareSelectedImageAt(cell: self)
    }
    
    @IBAction func retakeImageTapped(_ sender: Any) {
        retakeDelegate?.updateColelctionWhenImageDeletedAt(cell: self)
    }
    
}

protocol ImageShareAndRetakeDelegate {
    func updateColelctionWhenImageDeletedAt(cell : UICollectionViewCell)
    func shareSelectedImageAt(cell : UICollectionViewCell)
}
