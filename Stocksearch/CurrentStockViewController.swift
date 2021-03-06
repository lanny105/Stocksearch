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
import FBSDKCoreKit
import FBSDKShareKit




class CurrentStockViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate{

    
    
    var Symboljson:JSON!
//    var Symbol:String!
    var Parajson:JSON!
    var transitionManager: TransitionManager!
    
    var isFirstLoad: Bool = true
    
    let button : FBSDKShareButton = FBSDKShareButton()
    
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    
    
    @IBOutlet weak var CurrentButton: UIButton!
    
    
    @IBOutlet weak var FBbutton: UIButton!
    
    @IBAction func ShareFB(sender: UIButton) {
//        button.sendActionsForControlEvents(.TouchUpInside)
        initFB()
    }

    
    
    var flag1:Int = 0
    var flag2:Int = 0
    
    var titles: [String] = ["Name","Symbol","Last Price", "Change", "Time and Date", "Market Cap", "Volume", "Change YTD", "High Price", "Low Price", "Opening Price"]
    
    var values : [String] = []
    
    var flag3: Bool = false
    
    
    
    
    
    @IBOutlet weak var StockTableView: UITableView!
    
    
    @IBOutlet weak var Starbutton: UIButton!
    
    @IBAction func StarStock(sender: UIButton) {
        
        
//        StockTableView.reloadData()
        

        
        
        
        if !flag3  {

            let str = "insert into favoritelist ('Symbol') values('" + Symbol + "');"
//            print(str)
            SD.executeQuery(str)
            flag3 = true
            let image = UIImage(named: "Star-Filled.png")! as UIImage
            Starbutton.setBackgroundImage(image, forState: UIControlState.Normal)
            favouristList.append(Symbol)
            
        }
        
        else {
            let str = "delete from favoritelist where Symbol = '" + Symbol + "';"
            SD.executeQuery(str)
//            print(str)
            flag3 = false
            let image = UIImage(named: "Star-untapped.png")! as UIImage
            Starbutton.setBackgroundImage(image, forState: UIControlState.Normal)
            favouristList.removeAtIndex(favouristList.indexOf(Symbol)!)
            
        }
    }
    
    
    
    
    
    
    func rounded(a:NSNumber) -> String {
        return String(Double(round(100*Double(a))/100))
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
        
        self.values.append("$" + rounded(StockJson["LastPrice"].numberValue))
        
        self.values.append(rounded(StockJson["Change"].numberValue) + "(" + rounded(StockJson["ChangePercent"].numberValue) + "%)")
        
        if Double(StockJson["ChangePercent"].numberValue) < 0 {
            flag1 = -1
        }
        
        if Double(StockJson["ChangePercent"].numberValue) > 0 {
            flag1 = 1
        }
        

        
        self.values.append(StockJson["Timestamp"].rawString()!.substringToIndex(StockJson["Timestamp"].rawString()!.startIndex.advancedBy(22)))
        
        
        if StockJson["MarketCap"].intValue  > 1000000000 {
            self.values.append(rounded(StockJson["MarketCap"].intValue/1000000000) + " Billion")
        }
        
        else if StockJson["MarketCap"].intValue  > 1000000{
            self.values.append(rounded(StockJson["MarketCap"].intValue/1000000) + " Million")

        }
        
        else {
            self.values.append(rounded(StockJson["MarketCap"].intValue))
        }
        
        
        self.values.append(StockJson["Volume"].rawString()!)
        
        self.values.append(rounded(StockJson["ChangeYTD"].intValue) + "(" + rounded(StockJson["ChangePercentYTD"].intValue) + "%)")
        
        
        if Double(StockJson["ChangePercentYTD"].numberValue) < 0 {
            flag2 = -1
        }
        
        if Double(StockJson["ChangePercentYTD"].numberValue) > 0 {
            flag2 = 1
        }
        
        
        self.values.append("$" + rounded(StockJson["High"].numberValue))
        self.values.append("$" + rounded(StockJson["Low"].numberValue))
        self.values.append("$" + rounded(StockJson["Open"].numberValue))
        
    }
    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionManager = TransitionManager()
        //        let transitionManager = TransitionManager()
        CurrentButton.backgroundColor = UIColor.blueColor()
        CurrentButton.titleLabel?.textColor = UIColor.whiteColor()
        self.NavigationItem.title = Symbol
        
        prepareStockJson()
        StockTableView.allowsSelection  = false;
//        initFB()
        if favouristList.indexOf(Symbol) != nil {
            
            
            flag3 = true
            let image = UIImage(named: "Star-Filled.png")! as UIImage
            Starbutton.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        
        else {
            flag3 = false
            let image = UIImage(named: "Star-untapped.png")! as UIImage
            Starbutton.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        
        
        
        
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
//                destinationVC.Symbol = Symbol
            
            }
        }
        
        if segue.identifier == "CurrentToNews" {
            if let destinationVC = segue.destinationViewController as? NewsFeedViewController {
                destinationVC.transitioningDelegate = self.transitionManager
//                destinationVC.Symbol = Symbol
            }
        }
        
        if segue.identifier == "CurrentToMain" {
            if let destinationVC = segue.destinationViewController as? ViewController {
                destinationVC.getFavouriteList()
                destinationVC.transitioningDelegate = self.transitionManager
            }
        }
    }
    
    
    @IBAction func SwitchToHistorical(sender: UIButton) {
        self.performSegueWithIdentifier("CurrentToHistorical", sender: self)
    }
    
    
    @IBAction func SwitchToNews(sender: UIButton) {
        self.performSegueWithIdentifier("CurrentToNews", sender: self)
    }

    
    
    
    func initFB() {

        let dialog = FBSDKShareDialog()
        
        dialog.delegate = self
        dialog.mode = FBSDKShareDialogMode.FeedBrowser
        dialog.fromViewController = self
        dialog.shareContent = FBSDKShareLinkContent()
        
        
        
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://finance.yahoo.com/q?s=" + Symbol)
        content.contentTitle = "Current Stock Price of " + StockJson["Name"].rawString()! + " is $" + rounded(StockJson["LastPrice"].numberValue)
        content.contentDescription = "Stock Information of " + StockJson["Name"].rawString()! + "(" + Symbol + ")"
        content.imageURL = NSURL(string: "https://chart.finance.yahoo.com/t?s=" + Symbol + "&lang=en-US&width=300&height=250")
        
        dialog.shareContent = content
        
        
        dialog.show()
//        button.shareContent = content
        
        
        
//        self.view.addSubview(button)
    }

    
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.drawInRect(CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        
        if indexPath.row < titles.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CurrentStockCell
            
            cell.title.text = titles[indexPath.row]
            
            cell.value.text = values[indexPath.row]
            
            
            if indexPath.row == 3 {
                if flag1 == 1 {
                    let imageName = "Up-52.png"
                    cell.Indicator.image = UIImage(named: imageName)
                }
                
                if flag1 == -1 {
                    let imageName = "Down-52.png"
                    cell.Indicator.image = UIImage(named: imageName)
                }
            }

            if indexPath.row == 7 {
                if flag2 == 1 {
                    let imageName = "Up-52.png"
                    cell.Indicator.image = UIImage(named: imageName)
                }
                
                if flag2 == -1 {
                    let imageName = "Down-52.png"
                    cell.Indicator.image = UIImage(named: imageName)
                }
            }
            
            
            
            return cell
        }
        
        else {
//            StockTableView. = 300.0
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CurrentStockImageViewCell
            
            if let url = NSURL(string: "https://chart.finance.yahoo.com/t?s=" + Symbol + "&lang=en-US&width=300&height=250") {
                if let data = NSData(contentsOfURL: url) {
                    cell.StockImage.image = UIImage(data: data)                }
            }
            
            return cell

        }

        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < titles.count {
            return 40.0
            
        }
        else {
            return 300.0
        }
        
        
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count+1
    }
    
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        let alert = UIAlertController(title: "Post Canceled", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        let alert = UIAlertController(title: "Post Failed with Error", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if(results["postId"]==nil){
            self.sharerDidCancel(sharer)
        }
        else{
            let alert = UIAlertController(title: "Post Successfully", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
