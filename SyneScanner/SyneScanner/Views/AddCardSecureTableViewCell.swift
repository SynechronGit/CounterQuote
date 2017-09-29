//
//  AddCardSecureTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardSecureTableViewCell: UITableViewCell {
    @IBOutlet weak var validField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    
    var actionDelegate : SecureTextFieldActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddCardSecureTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField.tag == 2 {
            return newLength <= 3
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        actionDelegate?.secureTextFieldTappedAt(cell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol SecureTextFieldActionDelegate {
    func secureTextFieldTappedAt(cell: AddCardSecureTableViewCell)
}
