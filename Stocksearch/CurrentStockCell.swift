//
//  CurrentStockCell.swift
//  Stocksearch
//
//  Created by apple on 5/3/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class CurrentStockCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.title.font = UIFont.boldSystemFontOfSize(13.0)
        
    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
