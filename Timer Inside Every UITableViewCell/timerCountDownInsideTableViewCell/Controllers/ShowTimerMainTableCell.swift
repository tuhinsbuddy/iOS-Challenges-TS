//
//  ShowTimerMainTableCell.swift
//  timerCountDownInsideTableViewCell
//
//  Created by Tuhin Samui on 26/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ShowTimerMainTableCell: UITableViewCell {

    @IBOutlet weak var progressValueUpdateLbl: UILabel!
    @IBOutlet weak var showTimerMainSuperView: UIView!
    @IBOutlet weak var showTimerMainStackView: UIStackView!
    @IBOutlet weak var showTimerFirstTxtLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

