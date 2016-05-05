//
//  ViewController.swift
//  Stocksearch
//
//  Created by apple on 4/30/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit


import CCAutocomplete
import SwiftyJSON
import Alamofire




class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var refresh: UIButton!
    var refreshImage:UIImage!
    
    @IBOutlet weak var Stockinput: UITextField!
    
    @IBOutlet weak var AutocompleteContainerView: UIView!
    
    @IBOutlet weak var LblSelectedStockName: UILabel!
    
    
    @IBOutlet weak var FavouriteTableView: UITableView!
    
    var isFirstLoad: Bool = true
    
//    let countriesList = countries
    
    
    var tapAutocomplete = false
    
    
    var Lookupjson:JSON!
//    var Symbol:String!
    
    var transitionManager: TransitionManager!
    
    
    var Symbols:[String] = ["AAPL","GOOGL","MSFT"]
    
    
    
    var StockPrices:[String] = []
    var Changes:[String] = []
    var CompanyNames: [String] = []
    var MarketCaps: [String] = []
    
    
    
    var JSONlist: [JSON] = [JSON](count: 3, repeatedValue: JSON.null)
    var someDict = [String: Int]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        refresh.setImage(UIImage(named:"Refresh.png"), forState: .Normal)
        self.transitionManager = TransitionManager()
        getFavouriteList()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // this gets a reference to the screen that we're about to transition to
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        
        
        if segue.identifier == "SegueToCurrentStockControllerView" {
            if let destinationVC = segue.destinationViewController as? CurrentStockViewController {
                destinationVC.transitioningDelegate = self.transitionManager
//                destinationVC.Symboljson = self.Lookupjson
//                destinationVC.Symbol = self.Symbol
                
                
            }
        }
    }
    
    
    func rounded(a:NSNumber) -> String {
        return String(Double(round(100*Double(a))/100))
    }
    
    
    func getFavouriteList() {
        
//        StockJson = self.Lookupjson["market"]
        
        
        
        self.JSONlist = [JSON](count: 3, repeatedValue: JSON.null)

        var count = 0
        
        
        for sym in Symbols {
            someDict[sym] = count
            count+=1
        }
        

        
        
        var count2 = 0
        
        
        
        for sym in Symbols {

            
            Alamofire.request(.GET, "https://stocksearch-1297.appspot.com/index.php", parameters: ["Symbol": sym])
                .responseJSON { response in
                    
                    switch response.result {
                    case .Success:
                        
                        
                        
                        if let value = response.result.value {
                            let temp = JSON(value)
                            count2+=1
//                            print(temp)
                            
                            self.JSONlist[self.someDict[temp["market"]["Symbol"].rawString()!]!] = temp["market"]
//                            print(self.JSONlist.count)
//                            self.FavouriteTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.JSONlist.count, inSection: 0)], withRowAnimation: .Automatic)
                        }
                        
                        
                        if count2 == self.Symbols.count {
                            self.FavouriteTableView.reloadData()
                            print("load了！")
                        }
                        
                        
                    case .Failure(let error):
                        print(error)
                    }
            }
            
        }
        
    }
    
    
    
    func move(input: String) {

        
        
        Alamofire.request(.GET, "https://stocksearch-1297.appspot.com/index.php", parameters: ["Symbol": input])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        
                        self.Lookupjson = JSON(value)
                        
                        StockJson = self.Lookupjson["market"]
                        
                        NewsJson = self.Lookupjson["newsfeed"]
                        
                        self.performSegueWithIdentifier("SegueToCurrentStockControllerView", sender: self)
                        
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
        
        return

    }
    
    
    
    
    
    
    
    
    @IBAction func Getquote(sender: UIButton) {
        
        
        let validInput = Stockinput.text?.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if validInput == "" {
            let alertController = UIAlertController(title: "Please Enter a Stock Name or Symbol", message: "", preferredStyle: .Alert)
            
            // Initialize Actions
            let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                return
            }
            
            // Add Actions
            alertController.addAction(yesAction)
            
            // Present Alert Controller
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        if self.tapAutocomplete {
//            print(self.Lookupjson)
            
            if let index = validInput?.uppercaseString.characters.indexOf("-") {
//                print("Index: \(index)")
                
                Symbol = (validInput?.substringToIndex(index))!
                
//                print(self.Symbol)
                
                Alamofire.request(.GET, "https://stocksearch-1297.appspot.com/index.php", parameters: ["Symbol": Symbol])
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            
                            if let value = response.result.value {
                                
                                self.Lookupjson = JSON(value)
                                
                                StockJson = self.Lookupjson["market"]
                                
                                NewsJson = self.Lookupjson["newsfeed"]
                                
                            self.performSegueWithIdentifier("SegueToCurrentStockControllerView", sender: self)
                                
                            }
                            
                        case .Failure(let error):
                            print(error)
                        }
                    }
                
                
                return
            }
            
            

        }
        
        
        Alamofire.request(.GET, "https://stocksearch-1297.appspot.com/index.php", parameters: ["input": validInput!])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {

//                        print(value)
                        self.Lookupjson = JSON(value)
//                        print(self.Lookupjson)
                        
                        if self.Lookupjson["Message"] != JSON.null {
                            let alertController = UIAlertController(title: "Invalid Symbol", message: "", preferredStyle: .Alert)
                            
                            // Initialize Actions
                            let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                                return
                            }
                            
                            // Add Actions
                            alertController.addAction(yesAction)
                            
                            // Present Alert Controller
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            return

                        }
                        
                        
                        
                        for (_,subJson):(String, JSON) in self.Lookupjson {
                            
                            if self.Lookupjson["Symbol"] == JSON.null {
                                break
                            }
                            
                            if validInput == subJson["Symbol"].string! + "-" + subJson["Name"].string! + "-"+subJson["Exchange"].string! || validInput ==  subJson["Symbol"].string! {
                                print(self.Lookupjson)
                                
                                //还要大处理！！！
                                
                                self.performSegueWithIdentifier("SegueToCurrentStockControllerView", sender: self)
                                return
                            }
                            
                        }
                        
                        let alertController = UIAlertController(title: "Invalid Symbol", message: "", preferredStyle: .Alert)
                        
                        // Initialize Actions
                        let yesAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                            return
                        }
                        
                        // Add Actions
                        alertController.addAction(yesAction)
                        
                        // Present Alert Controller
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        return

                        
                        
                    }
                    
                case .Failure(let error):
                    print("this is err")
                    print(error)
                }
                
        }

    }
    
    @IBAction func refresh(sender: UIButton) {
        
//        print("hello")
        getFavouriteList()
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Symbols.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Symbols.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! FavouriteTableViewCell
        
        
        if JSONlist.count < Symbols.count {
            
//            print("xixi")
            cell.Symbol.text = Symbols[indexPath.row]
            return cell
            
        }
//        print("hehe")
//
//        
        if Double(JSONlist[indexPath.row]["ChangePercent"].numberValue) < 0 {
            cell.Change.backgroundColor = UIColor.redColor()
            cell.Change.textColor = UIColor.whiteColor()
        }
        
        if Double(JSONlist[indexPath.row]["ChangePercent"].numberValue) > 0 {
            cell.Change.backgroundColor = UIColor.greenColor()
            cell.Change.textColor = UIColor.whiteColor()
        }
        
        var str:String = ""
        
        if JSONlist[indexPath.row]["MarketCap"].intValue  > 1000000000 {
            str = rounded(JSONlist[indexPath.row]["MarketCap"].intValue/1000000000) + " Billion"
        }
            
        else if JSONlist[indexPath.row]["MarketCap"].intValue  > 1000000{
            str = rounded(JSONlist[indexPath.row]["MarketCap"].intValue/1000000) + " Million"
            
        }
            
        else {
            str = rounded(JSONlist[indexPath.row]["MarketCap"].intValue)
        }
        
        cell.Change.text = rounded(JSONlist[indexPath.row]["Change"].numberValue) + "(" + rounded(JSONlist[indexPath.row]["ChangePercent"].numberValue) + "%)"
        cell.CompanyName.text = JSONlist[indexPath.row]["Name"].rawString()!
        cell.MarketCap.text = "Market Cap: " + str
        cell.Symbol.text = JSONlist[indexPath.row]["Symbol"].rawString()!
        
        print(cell.Symbol.text)
        print(indexPath.row)
        
        cell.StockPrice.text = "$" + rounded(JSONlist[indexPath.row]["LastPrice"].numberValue)

        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        Symbol = Symbols[indexPath.row]
        move(Symbol)
    }
    
    


}



extension ViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.Stockinput
    }
    func autoCompleteThreshold(textField: UITextField) -> Int {
        return 0
    }
    
    
    func autoCompleteItemsForSearchTerm(term: String) -> [AutocompletableOption] {
        
        return []
    }
    
    
    func autoCompleteTextChange() ->Void {
        self.tapAutocomplete = false
    }
    
    func autoCompleteHeight() -> CGFloat {
        return CGRectGetHeight(self.view.frame) / 3.0
    }
    
    
    func didSelectItem(item: AutocompletableOption) {
        self.LblSelectedStockName.text = item.text
        self.tapAutocomplete = true
//        print(self.Lookupjson)
//        print(Stockinput.text)
    }
}

