//
//  BestQuoteOfferedTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 16/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class BestQuoteOfferedTableViewCell: UITableViewCell {
    @IBOutlet weak var lblQuoteAmount: UILabel!
    @IBOutlet weak var lblYouSaveAmount: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
