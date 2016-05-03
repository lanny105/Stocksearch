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




class ViewController: UIViewController {

    @IBOutlet weak var refresh: UIButton!
    var refreshImage:UIImage!
    
    @IBOutlet weak var Stockinput: UITextField!
    
    @IBOutlet weak var AutocompleteContainerView: UIView!
    
    @IBOutlet weak var LblSelectedStockName: UILabel!
    
    var isFirstLoad: Bool = true
    
//    let countriesList = countries
    
    
    var tapAutocomplete = false
    
    
    var Lookupjson:JSON!
    var Symbol:String!
    
    var transitionManager: TransitionManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.setImage(UIImage(named:"Refresh-64.png"), forState: .Normal)
        self.transitionManager = TransitionManager()
        
        
        
        
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
                destinationVC.Symboljson = self.Lookupjson
                destinationVC.Symbol = self.Symbol
            }
        }
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
                print("Index: \(index)")
                
                self.Symbol = validInput?.substringToIndex(index)
                
                print(self.Symbol)
                
                Alamofire.request(.GET, "https://stocksearch-1297.appspot.com/index.php", parameters: ["Symbol": self.Symbol])
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            
                            if let value = response.result.value {
                                
                                self.Lookupjson = JSON(value)
                                
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
        
        print("hello")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
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

