//
//  File.swift
//  Langs
//
//  Created by apple on 9/28/15.
//  Copyright © 2015 mg526. All rights reserved.
//

import Foundation



extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathExtension(ext)
    }
}

private let _sharedYQDataMediator = YQDataMediator()

class YQDataMediator {
    
    class var instance : YQDataMediator {
        return _sharedYQDataMediator
    }
    
    
    
    func getPath(fileName: String) -> String {
        
        
        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(fileName)
    }
    
    func copyFile(fileName: NSString) {
        
        
        let (tables, _) = SD.existingTables()
        
        if let _ = tables.indexOf("symbol"){
            
            print("Database exists!")
            return
        }
        
        
        let dbPath: String = getPath(fileName as String)
        let fileManager = NSFileManager.defaultManager()
        
        
        let fromPath: String? = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(fileName as String)
        
        //fileManager.copyItemAtPath(fromPath!, toPath: dbPath)
        /*
         NSData myData = [NSData dataWithContentsOfURL:FileURL]; /fetch single file
         [myData writeToFile:targetPath atomically:YES];
         */
        
        var error : NSError?
        do {
            
            try fileManager.removeItemAtPath(dbPath)
            try fileManager.copyItemAtPath(fromPath!, toPath: dbPath)
        } catch let error1 as NSError {
            error = error1
            
            //print("完了！")
            print(error)
        }
        
        print("\(fromPath)")
        print("\(dbPath)")
        
        
    }
    
    
    
    
    
    func getConstellation() -> NSArray {
        
        
        // levelID
        // levelName
        // levelCat
        //        NSDictionary("levelID" )
        //        int, string, int
        
        var myArrayOfDict: [NSDictionary] = []
        //        NSDictionary()
        
        //select con_id, name,category from Constellation
        
        var (resultSet, err) = SD.executeQuery("select * from Constellation")
        
        if err != nil {
            //there was an error during the query, handle it here
        } else {
            
            for row in resultSet {
                var dic = [ "levelID" : "", "levelName": "" , "levelCat": ""]
                
                if let con_id = row["Con_ID"]?.asInt() {
                    //                    print("The Star name is: \(ID)")
                    //temp_star.id = ID
                    
                    //                    print("111111----",con_id)
                    dic["levelID"] = String(con_id)
                    
                }
                
                if let name = row["Name"]?.asString() {
                    //println("The Star Hip is: \(Hip)")
                    
                    //                    print("222222-----",name)
                    dic["levelName"] = name
                }
                
                
                if let category = row["category"]?.asInt() {
                    //                    print("The Star Hd is: \(Hd)")
                    dic["levelCat"] = String(category)
                    
                    //                    print("333333------",category)
                }
                
                myArrayOfDict.append(dic)
                
            }
            
            
            
        }
        
        
        return myArrayOfDict
    }
}