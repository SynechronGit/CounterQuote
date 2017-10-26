//
//  QuoteFormTableViewCell.swift
//  SyneScanner
//
//  Created by Markel on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class QuoteFormTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cellDividerImage: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!

    var quoteDelegate : QuoteTextFieldDelegate?
    
    // MARK: - TableView cell initial methods
    override func awakeFromNib() {
        descriptionField.delegate = self
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


// MARK: - UITextField delegate methods
extension QuoteFormTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        quoteDelegate?.textFieldTappedAt(cell: self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        quoteDelegate?.textFieldReturnedFor(cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TextFieldActionDelegate protocol
protocol QuoteTextFieldDelegate {
    func textFieldTappedAt(cell: QuoteFormTableViewCell)
    func textFieldReturnedFor(cell: QuoteFormTableViewCell)
}
