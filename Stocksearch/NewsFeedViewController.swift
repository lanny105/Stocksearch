//
//  NewsFeedViewController.swift
//  Stocksearch
//
//  Created by apple on 5/2/16.
//  Copyright © 2016 apple. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var Symboljson:JSON!
    var Parajson:JSON!
    var transitionManager: TransitionManager!
    
    var isFirstLoad: Bool = true
    
    
    var titles: [String] = []
    var discrptions :[String] = []
    var sources: [String] = []
    var dates: [String] = []
    var urls: [String] = []
    
    
    
    @IBOutlet weak var NewsButton: UIButton!
    
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionManager = TransitionManager()
        
        self.NavigationItem.title = Symbol
        
        parsejson()

        NewsButton.backgroundColor = UIColor.blueColor()
        NewsButton.titleLabel?.textColor = UIColor.whiteColor()
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
        
        if segue.identifier == "NewsToCurrent" {
            if let destinationVC = segue.destinationViewController as? CurrentStockViewController {
                destinationVC.transitioningDelegate = self.transitionManager
            }
        }
        
        
        if segue.identifier == "NewsToHistorical" {
            if let destinationVC = segue.destinationViewController as? HistoricalChartViewController {
                destinationVC.transitioningDelegate = self.transitionManager
            }
        }
    }
    
    func parsejson() {
        
        if  NewsJson["d"]["results"] != JSON.null {
            for (_,subJson):(String, JSON) in NewsJson["d"]["results"] {
                titles.append(subJson["Title"].rawString()!)
                discrptions.append(subJson["Description"].rawString()!)
                sources.append(subJson["Source"].rawString()!)
                dates.append(subJson["Date"].rawString()!)
                urls.append(subJson["Url"].rawString()!)
            }
        }
    }
    
    @IBAction func SwitchToCurrent(sender: UIButton) {
        self.performSegueWithIdentifier("NewsToCurrent", sender: self)
    }
    

    @IBAction func SwitchToHistorical(sender: UIButton) {
        self.performSegueWithIdentifier("NewsToHistorical", sender: self)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsJson["d"]["results"].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! NewsTableViewCell
            
        cell.NewsTitle.text = titles[indexPath.row]
        cell.NewsDiscription.text = discrptions[indexPath.row]
        cell.NewsSource.text = sources[indexPath.row]
        cell.NewsDate.text = dates[indexPath.row]
        return cell
        
    }
    
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        return 640.0
//        
//    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let url = NSURL(string: urls[indexPath.row]) {
            UIApplication.sharedApplication().openURL(url)
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
