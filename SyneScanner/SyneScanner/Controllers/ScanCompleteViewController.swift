//
//  ScanCompleteViewController.swift
//  SyneScanner
//
//  Created by Kartik on 22/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class ScanCompleteViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIButton action methods

    @IBAction func scanningDoneTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ScanCompleteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK: UICollectionView DataSource methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SharedData.sharedInstance.arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ImageReviewCollectionViewCell
        let model = SharedData.sharedInstance.arrImage[indexPath.row]
        cell.imageReview.image = model.image
        return cell
    }
    
}
