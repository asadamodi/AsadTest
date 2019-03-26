//
//  WeatherTableViewCell.swift
//  AsadTest
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var m_cityNamelbl: UILabel!
    
    @IBOutlet weak var m_tempraturelbl: UILabel!
    
    @IBOutlet weak var m_humiditylbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
