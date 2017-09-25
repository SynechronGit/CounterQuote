//
//  ImagePreviewController.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController {
    // MARK: - Properties
    
    var deleteDelegate : ImageDeleteDelegate?
    @IBOutlet var collectionView: UICollectionView!

     // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        let rightBarButton = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ImagePreviewController.finishBtnTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishBtnTapped()
    {
        self.performSegue(withIdentifier: "NavToStartWorkFlow", sender: nil)
    }
   
       
   }

 // MARK: - UICollection View DataSource and Delegate Method
extension ImagePreviewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SharedData.sharedInstance.arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewCollectionViewCell
       let model = SharedData.sharedInstance.arrImage[indexPath.row]
        cell.imagePreview.image = model.image
        cell.retakeDelegate = self
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        print(width,height)
        return CGSize(width: width, height: height)
    }
    
   
}

// MARK: - ImagePreviewCollectionViewCell Delegate Method

extension ImagePreviewController:ImageShareAndRetakeDelegate
{
    func updateColelctionWhenImageDeletedAt(cell : UICollectionViewCell)
    {
        let indexPath = self.collectionView.indexPath(for: cell)
        deleteDelegate?.updateCollectionWhenImageDeletedAt(index: (indexPath?.row)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func shareSelectedImageAt(cell : UICollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        let model = SharedData.sharedInstance.arrImage[(indexPath?.row)!]

        let image:UIImage = model.image!
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}


protocol ImageDeleteDelegate {
    func updateCollectionWhenImageDeletedAt(index : Int)
}

protocol ImageUploadOnBackActionDelegate {
    func uploadImageOnBackAction()
}
