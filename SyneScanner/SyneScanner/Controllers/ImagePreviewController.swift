//
//  ImagePreviewController.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

protocol ImageDeleteDelegate {
    func updateColectionWhenImageDeletedAt(index : Int)
}

class ImagePreviewController: UIViewController {
    var deleteDelegate : ImageDeleteDelegate?
    var imageArr:[UIImage]?
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = IndexPath(item: (self.imageArr?.count)! - 1, section: 0)
        self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.right, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
   }

extension ImagePreviewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (imageArr?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewCollectionViewCell
       
        cell.imagePreview.image = imageArr?[indexPath.row]
        cell.deleteDelegate = self
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
   
}

extension ImagePreviewController:ImageShareAndDeleteDelegate
{
    func updateColelctionWhenImageDeletedAt(cell : UICollectionViewCell)
    {
        let indexPath = self.collectionView.indexPath(for: cell)
        imageArr?.remove(at: (indexPath?.row)!)
        deleteDelegate?.updateColectionWhenImageDeletedAt(index: (indexPath?.row)!)
        self.collectionView.reloadData()
        if imageArr?.count == 0 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func shareSelectedImageAt(cell : UICollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        if let image = imageArr?[(indexPath?.row)!] {
            let imageToShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
