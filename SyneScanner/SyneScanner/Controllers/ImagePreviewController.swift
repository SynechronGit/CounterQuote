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
    var isFromScanComplete:Bool = false
    var selectedIndexNo = -1
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lblHeader: UILabel!

     // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI()
    {
        self.title = "Preview"
        
        if isFromScanComplete
        {
            pageControl.isHidden =  true
            lblHeader.isHidden = true
        }
        
        pageControl.numberOfPages = SharedData.sharedInstance.arrImage.count
        
        lblHeader.text = String(format:"You are in (1/%d) pages",pageControl.numberOfPages)

        //let rightBarButton = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ImagePreviewController.finishBtnTapped))
        //self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        
        collectionView.reloadData()

    }
   @IBAction func popToRoot()
    {
        self.navigationController?.popViewController(animated: true)
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
        if isFromScanComplete
        {
            return 1
        }
        return SharedData.sharedInstance.arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewCollectionViewCell
        
        var model:ImageDataModel?
        
        if isFromScanComplete
        {
            model = SharedData.sharedInstance.arrImage[selectedIndexNo]

        }
        else
        {
            model = SharedData.sharedInstance.arrImage[indexPath.row]
   
        }
        cell.imagePreview.image = model?.image
        cell.retakeDelegate = self
        
        cell.retakeButton.layer.borderWidth = 1
         cell.retakeButton.layer.cornerRadius = 22
         cell.retakeButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor

        cell.deleteButton.layer.borderWidth = 1
        cell.deleteButton.layer.cornerRadius = 22
        cell.deleteButton.layer.borderColor = UIColor(red: 53/255, green: 28/255, blue: 71/255, alpha: 1).cgColor
        
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        
        lblHeader.text = String(format:"You are in (%d/%d) pages",pageControl.currentPage + 1,pageControl.numberOfPages)
    }
}

// MARK: - ImagePreviewCollectionViewCell Delegate Method

extension ImagePreviewController:ImageShareAndRetakeDelegate
{
    func retakeImageAt(cell : UICollectionViewCell)
    {
        if isFromScanComplete
        {

            deleteDelegate?.updateCollectionWhenImageretakeAt(index: (selectedIndexNo))
            let vc = self.navigationController?.viewControllers[2]
            self.navigationController?.popToViewController(vc!, animated: true)
        
        }
        else
        {
            let indexPath = self.collectionView.indexPath(for: cell)

            deleteDelegate?.updateCollectionWhenImageretakeAt(index: (indexPath?.row)!)
            self.navigationController?.popViewController(animated: true)
        }
      

    }
    func deleteImageAt(cell : UICollectionViewCell)
    {
        if isFromScanComplete
        {
           // SharedData.sharedInstance.arrImage.remove(at: selectedIndexNo)
        }
        else
        {
            let indexPath = self.collectionView.indexPath(for: cell)
            deleteDelegate?.updateCollectionWhenImageDeletedAt(index: (indexPath?.row)!)
        }
      
        self.navigationController?.popViewController(animated: true)

    }
    func updateColelctionWhenImageDeletedAt(cell : UICollectionViewCell)
    {
    }
    
    
}


protocol ImageDeleteDelegate {
    func updateCollectionWhenImageDeletedAt(index : Int)
    func updateCollectionWhenImageretakeAt(index : Int)

}


