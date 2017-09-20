//
//  ImagePreviewCollectionViewCell.swift
//  SyneScanner
//
//  Created by Markel on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ImagePreviewCollectionViewCell: UICollectionViewCell {
    var deleteDelegate : ImageShareAndDeleteDelegate?
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBAction func shareImageOptionsTapped(_ sender: Any) {
        deleteDelegate?.shareSelectedImageAt(cell: self)
    }
    
    @IBAction func deleteImageTapped(_ sender: Any) {
        deleteDelegate?.updateColelctionWhenImageDeletedAt(cell: self)
    }
    
}

protocol ImageShareAndDeleteDelegate {
    func updateColelctionWhenImageDeletedAt(cell : UICollectionViewCell)
    func shareSelectedImageAt(cell : UICollectionViewCell)
}
