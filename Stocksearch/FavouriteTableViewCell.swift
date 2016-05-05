//
//  FavouriteTableViewCell.swift
//  Stocksearch
//
//  Created by apple on 5/4/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Symbol: UILabel!
    
    
    @IBOutlet weak var StockPrice: UILabel!
    
    @IBOutlet weak var Change: UILabel!
    
    
    @IBOutlet weak var CompanyName: UILabel!
    
    @IBOutlet weak var MarketCap: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
