//
//  CurrentStockViewController.swift
//  Stocksearch
//
//  Created by apple on 5/2/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire




class CurrentStockViewController: UIViewController, UITableViewDataSource{

    
    
    var Symboljson:JSON!
    var Symbol:String!
    var Parajson:JSON!
    var transitionManager: TransitionManager!
    
    var isFirstLoad: Bool = true
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var CurrentButton: UIButton!
    
    
    var titles: [String] = ["Name","Symbol","Last Price", "Change", "Time and Date", "Market Cap", "Volume", "Change YTD", "High Price", "Low Price", "Opening Price"]
    
    var values : [String] = []
    
    
    
    @IBOutlet weak var StockTableView: UITableView!
    
    
    
    
    @IBOutlet weak var StockChart: UIImageView!
    
    
    
    
    
    
    
    func loadImage() {
        if let url = NSURL(string: "https://chart.finance.yahoo.com/t?s=" + self.Symbol + "&lang=en-US&width=300&height=300") {
            if let data = NSData(contentsOfURL: url) {
                StockChart.image = UIImage(data: data)
            }
        }
        
    }
    
    
    
    func prepareStockJson() {
        
//    {
//        "Name" : "Alphabet Inc",
//        "Volume" : 98037,
//        "LastPrice" : 708.37,
//        "MSDate" : 42493.665972222,
//        "MarketCap" : 243049539070,
//        "ChangeYTD" : 778.01,
//        "Low" : 707.75,
//        "Timestamp" : "Tue May 3 15:59:00 UTC-04:00 2016",
//        "ChangePercentYTD" : -8.9510417603887,
//        "Symbol" : "GOOGL",
//        "Status" : "SUCCESS",
//        "Open" : 711.48,
//        "ChangePercent" : -0.84545289119693,
//        "Change" : -6.04,
//        "High" : 713.2
//    }
        
        
        
        self.values.append(StockJson["Name"].rawString()!)
        self.values.append(StockJson["Symbol"].rawString()!)
        self.values.append("$" + StockJson["LastPrice"].rawString()!)
        self.values.append(StockJson["Change"].rawString()! + "(" + StockJson["ChangePercent"].rawString()! + ")")
        self.values.append(StockJson["Timestamp"].rawString()!)
        self.values.append(StockJson["MarketCap"].rawString()!)
        self.values.append(StockJson["Volume"].rawString()!)
        self.values.append(StockJson["ChangeYTD"].rawString()! + "(" + StockJson["ChangePercentYTD"].rawString()! + ")")
        self.values.append("$" + StockJson["High"].rawString()!)
        self.values.append("$" + StockJson["Low"].rawString()!)
        self.values.append("$" + StockJson["Open"].rawString()!)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionManager = TransitionManager()
        //        let transitionManager = TransitionManager()
        CurrentButton.backgroundColor = UIColor.blueColor()
        CurrentButton.titleLabel?.textColor = UIColor.whiteColor()
        self.NavigationItem.title = self.Symbol
        
        
        
        
        loadImage()
        
        prepareStockJson()

        

        
        

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // this gets a reference to the screen that we're about to transition to
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        
        
        
        
        
        
        if segue.identifier == "CurrentToHistorical" {
            if let destinationVC = segue.destinationViewController as? HistoricalChartViewController {
                destinationVC.transitioningDelegate = self.transitionManager
                destinationVC.Symbol = self.Symbol
            }
        }
        
        
        if segue.identifier == "CurrentToNews" {
            if let destinationVC = segue.destinationViewController as? NewsFeedViewController {
                destinationVC.transitioningDelegate = self.transitionManager
                destinationVC.Symbol = self.Symbol
            }
        }
        
    }

    
    @IBAction func SwitchToHistorical(sender: UIButton) {
        self.performSegueWithIdentifier("CurrentToHistorical", sender: self)
    }
    
    
    @IBAction func SwitchToNews(sender: UIButton) {
        self.performSegueWithIdentifier("CurrentToNews", sender: self)
    }


    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CurrentStockCell
        
        cell.title.text = titles[indexPath.row]
        
        cell.value.text = values[indexPath.row]
        

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
