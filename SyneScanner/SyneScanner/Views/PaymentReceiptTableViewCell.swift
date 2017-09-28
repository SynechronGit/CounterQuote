//
//  PaymentReceiptTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 28/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class PaymentReceiptTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
