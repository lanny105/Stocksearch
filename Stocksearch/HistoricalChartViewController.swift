//
//  HistoricalChartViewController.swift
//  Stocksearch
//
//  Created by apple on 5/2/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JavaScriptCore

class HistoricalChartViewController: UIViewController, UIWebViewDelegate {

    var Symboljson:JSON!
    var Symbol:String!
    var Parajson:JSON!
    var transitionManager: TransitionManager!
    
    var isFirstLoad: Bool = true
    
    
    
    @IBOutlet weak var ChartWebView: UIWebView!
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    
    
    
    @IBOutlet weak var HistoricalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionManager = TransitionManager()
        
        self.NavigationItem.title = self.Symbol
        
        
        HistoricalButton.backgroundColor = UIColor.blueColor()
        HistoricalButton.titleLabel?.textColor = UIColor.whiteColor()
        

        
        let localfilePath = NSBundle.mainBundle().URLForResource("html", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        ChartWebView.loadRequest(myRequest);
        ChartWebView.scalesPageToFit = false
        
        
        
        ChartWebView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {

        ChartWebView.stringByEvaluatingJavaScriptFromString("hello(" + "\"" + String(self.Symbol) + "\");")
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // this gets a reference to the screen that we're about to transition to
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        
        
        if segue.identifier == "HistoricalToCurrent" {
            if let destinationVC = segue.destinationViewController as? CurrentStockViewController {
                destinationVC.transitioningDelegate = self.transitionManager
                destinationVC.Symbol = self.Symbol
            }
        }
        
        
        if segue.identifier == "HistoricalToNews" {
            if let destinationVC = segue.destinationViewController as? NewsFeedViewController {
                destinationVC.transitioningDelegate = self.transitionManager
                destinationVC.Symbol = self.Symbol
            }
        }
    }
    
    
    
    @IBAction func SwitchToCurrent(sender: UIButton) {
        self.performSegueWithIdentifier("HistoricalToCurrent", sender: self)
    }
    
    @IBAction func HistoricalToCurrent(sender: UIButton) {
        self.performSegueWithIdentifier("HistoricalToNews", sender: self)
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
