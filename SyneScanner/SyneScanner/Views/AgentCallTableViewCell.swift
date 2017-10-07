//
//  AgentCallTableViewCell.swift
//  SyneScanner
//
//  Created by Kartik on 06/10/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

class AgentCallTableViewCell: UITableViewCell {
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        callButton.layer.cornerRadius = 22
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callTapped(_ sender: Any) {
    }

}
