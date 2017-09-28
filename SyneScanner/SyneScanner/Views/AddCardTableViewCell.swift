//
//  AddCardTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 26/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AddCardTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        actionDelegate?.textFieldTappedAt(cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol TextFieldActionDelegate {
    func textFieldTappedAt(cell: AddCardTableViewCell)
}
