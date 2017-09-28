//
//  AddCardTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardTableViewCell: UITableViewCell {
    @IBOutlet weak var headerField: UITextField!
    
    @IBOutlet weak var cardImageView: UIImageView!
    var actionDelegate : TextFieldActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension AddCardTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        actionDelegate?.textFieldTappedAt(cell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol TextFieldActionDelegate {
    func textFieldTappedAt(cell: AddCardTableViewCell)
}
