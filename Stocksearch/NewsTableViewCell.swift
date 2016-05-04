//
//  NewsTableViewCell.swift
//  Stocksearch
//
//  Created by apple on 5/4/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var NewsDiscription: UILabel!
    
    @IBOutlet weak var NewsSource: UILabel!
    @IBOutlet weak var NewsDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.NewsTitle.font = UIFont.boldSystemFontOfSize(17.0)
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
