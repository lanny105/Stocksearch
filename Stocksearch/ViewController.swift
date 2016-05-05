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
import SpriteKit




class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var timer: NSTimer!
    
    
    @IBOutlet weak var refresh: UIButton!
    var refreshImage:UIImage!
    
    @IBOutlet weak var Stockinput: UITextField!
    
    @IBOutlet weak var AutocompleteContainerView: UIView!
    
    @IBOutlet weak var LblSelectedStockName: UILabel!
    
    
    @IBOutlet weak var FavouriteTableView: UITableView!
    
    
    @IBOutlet weak var Myswitch: UISwitch!
    
    @IBAction func Switched(sender: AnyObject) {
        
        if Myswitch.on {
            timer = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: Selector("getFavouriteList"), userInfo: nil, repeats: true)
        }
        
        else {
            timer.invalidate()
        }
        
    }
    
    
    
    
    
    var isFirstLoad: Bool = true
    
//    let countriesList = countries
    
    
    var tapAutocomplete = false
    
    
    var Lookupjson:JSON!
//    var Symbol:String!
    
    var transitionManager: TransitionManager!
    
    
//    var Symbols:[String] = ["AAPL","GOOGL","MSFT"]
    
    
    
    var StockPrices:[String] = []
    var Changes:[String] = []
    var CompanyNames: [String] = []
    var MarketCaps: [String] = []
    
    
    
    var JSONlist: [JSON] = []
    var someDict = [String: Int]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        refresh.setImage(UIImage(named:"Refresh.png"), forState: .Normal)
        self.transitionManager = TransitionManager()
        
        
        print((NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString))
        
        
        let (tables, _) = SD.existingTables()
        
        if let _ = tables.indexOf("favoritelist"){
            
            print("Database exists!")
            
        }
        
        else {
            if let err = SD.createTable("favoritelist", withColumnNamesAndTypes: ["Symbol": .StringVal]) {
                //there was an error during this function, handle it here
            } else {
                //no error, the table was created successfully
            }
        }
        
        
        favouristList = getSumbolList()
        
        getFavouriteList()
        
        self.Stockinput.delegate = self

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func getSumbolList() -> [String] {
        
        
        
        var SymbolList: [String] = []
        
        
        var (resultSet, err) = SD.executeQuery("select Symbol from favoritelist;")
        
        if err != nil {
            //there was an error during the query, handle it here
        } else {
            
            for row in resultSet {
                print(row)
                if let sym = row["Symbol"]?.asString() {
                    SymbolList.append(sym)
                }
                
            }
            
        }
        
        return SymbolList
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
    
    
    
//    var timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("getFavouriteList"), userInfo: nil, repeats: true)

    
    
    func getFavouriteList() {
        
//        StockJson = self.Lookupjson["market"]
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(115,390, 150, 150)) as UIActivityIndicatorView
//        actInd.center = self.view.center
        
        
        
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.color = UIColor(red: 46.0/255, green: 204.0/255, blue: 113.0/255, alpha: 1.0)
        view.addSubview(actInd)
        
        
        self.JSONlist = [JSON](count: favouristList.count, repeatedValue: JSON.null)

        var count = 0
        
        
        for sym in favouristList {
            someDict[sym] = count
            count+=1
        }
        
//        print(someDict)
        
        
        var count2 = 0
        
        
        
        
        for sym in favouristList {
            actInd.startAnimating()

            
            Alamofire.request(.GET, "http://www.mobileserver-1300.appspot.com/index.php", parameters: ["Symbol": sym])
                .responseJSON { response in
                    
                    switch response.result {
                    case .Success:
                        
                        if let value = response.result.value {
                            let temp = JSON(value)
                            count2+=1
                            //
                            
                            self.JSONlist[self.someDict[temp["Symbol"].rawString()!]!] = temp["market"]
                        }
                        
                        if count2 == favouristList.count {
                            self.FavouriteTableView.reloadData()
//                            print(self.JSONlist)
                            actInd.stopAnimating()
                        }
                        
                        
                    case .Failure(let error):
                        print(error)
                    }
            }
            
        }
        self.FavouriteTableView.reloadData()
        
    }
    
    
    
    func move(input: String) {

        
        
        Alamofire.request(.GET, "http://www.mobileserver-1300.appspot.com/index.php", parameters: ["Symbol": input])
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
                
                Alamofire.request(.GET, "http://www.mobileserver-1300.appspot.com/index.php", parameters: ["Symbol": Symbol])
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
        
        
        Alamofire.request(.GET, "http://www.mobileserver-1300.appspot.com/index.php", parameters: ["input": validInput!])
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
            
            let str = "delete from favoritelist where Symbol = '" + favouristList[indexPath.row] + "';"
            SD.executeQuery(str)
            
            
            favouristList.removeAtIndex(indexPath.row)
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
        return favouristList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! FavouriteTableViewCell
        
        
        if JSONlist.count < favouristList.count {
            
//            print("xixi")
            cell.Symbol.text = favouristList[indexPath.row]
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
        
//        print(cell.Symbol.text)
//        print(indexPath.row)
        
        cell.StockPrice.text = "$" + rounded(JSONlist[indexPath.row]["LastPrice"].numberValue)

        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        Symbol = favouristList[indexPath.row]
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

