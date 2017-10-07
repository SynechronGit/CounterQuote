//
//  AddCardTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardTableViewCell: UITableViewCell {
    let kLength = 4
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var cardScanBtn: UIButton!
    @IBOutlet weak var cellDividerImage: UIImageView!

    var actionDelegate : TextFieldActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cardScanBtnTapped()
    {
        actionDelegate?.showCardScanVc()
    }
}

extension AddCardTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        switch textField.tag {
        case 0:
            return newLength <= 19
        case 3:
            return true
        default:
            return true
        }
    }
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
     {
        actionDelegate?.textFieldTappedAt(cell: self)

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol TextFieldActionDelegate {
    func textFieldTappedAt(cell: AddCardTableViewCell)
    func showCardScanVc()
}
