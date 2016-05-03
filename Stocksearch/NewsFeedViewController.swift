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

class NewsFeedViewController: UIViewController {

    var Symboljson:JSON!
    var Symbol:String!
    var Parajson:JSON!
    var transitionManager: TransitionManager!
    
    @IBOutlet weak var NewsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionManager = TransitionManager()
//        print(Symboljson)
        print(Symbol)
        //        let transitionManager = TransitionManager()

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
                destinationVC.Symbol = self.Symbol
            }
        }
        
        
        if segue.identifier == "NewsToHistorical" {
            if let destinationVC = segue.destinationViewController as? HistoricalChartViewController {
                destinationVC.transitioningDelegate = self.transitionManager
                destinationVC.Symbol = self.Symbol
            }
        }
    }
    
    

    @IBAction func SwitchToCurrent(sender: UIButton) {
        self.performSegueWithIdentifier("NewsToCurrent", sender: self)
    }
    

    @IBAction func SwitchToHistorical(sender: UIButton) {
        self.performSegueWithIdentifier("NewsToHistorical", sender: self)
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
