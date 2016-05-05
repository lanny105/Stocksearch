//
//  File.swift
//  Langs
//
//  Created by apple on 9/28/15.
//  Copyright © 2015 mg526. All rights reserved.
//

import Foundation



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
        
        if let _ = tables.indexOf("starincon"){
            
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
        
        
        
    }
    
    
    /*
     
     class func getStarPrototype {
     <#properties and methods#>
     }
     
     */
    
    
    
    func getSumbolList() -> [String] {
        
        
        var SymbolList: [String] = []

        
        var (resultSet, err) = SD.executeQuery("select SYMBOL from favoritelist")
        
        if err != nil {
            //there was an error during the query, handle it here
        } else {
            
            for row in resultSet {

                if let sym = row["SYMBOL"]?.asString() {
                    SymbolList.append(sym)
                }
                
            }
    
        }
        
        return SymbolList
    }

    
    
    func insertSumbolList(sym: String) {
        
        
        
        var (resultSet, err) = SD.executeQuery("insert into favoritelist values('\(sym)')")
        
        if err != nil {
            //there was an error during the query, handle it here
        } else {
            
            return
            
        }
    }
    
    
    
//    func insertSumbolList(sym: String) {
//        
//        
//        
//        var (resultSet, err) = SD.executeChange("insert into favoritelist values('\(sym)')")
//        
//        if err != nil {
//            //there was an error during the query, handle it here
//        } else {
//            
//            return
//            
//        }
//    }
    
    
    
    
    
    

    
    
    
    
    
//    func getStarByAttr(level: Int) -> NSArray{
//        
//        var Starlist: [Star] = []
//        //var ran = random() % 300
//        let (resultSet, err) = SD.executeQuery("SELECT * FROM Startrix_2 WHERE MAG < 3.5 OR CON_ID = \(level)")
//        
//        if err != nil {
//            //there was an error during the query, handle it here
//        } else {
//            
//            
//            for row in resultSet {
//                
//                let temp_star = Star()
//                
//                if let ID = row["ID"]?.asInt() {
//                    //print("The Star name is: \(ID)")
//                    temp_star.id = ID
//                }
//                
//                if let Hip = row["Hip"]?.asInt() {
//                    //println("The Star Hip is: \(Hip)")
//                    temp_star.hip = Hip
//                }
//                
//                
//                if let Hd = row["Hd"]?.asInt() {
//                    //                    print("The Star Hd is: \(Hd)")
//                    temp_star.hd = Hd
//                }
//                
//                
//                if let Bf = row["Bf"]?.asString() {
//                    //println("The Star Bf is \(Bf)")
//                    temp_star.bf = Bf
//                }
//                
//                if let Proper = row["Proper"]?.asString() {
//                    //println("The Star Proper is \(Proper)")
//                    
//                    temp_star.proper = Proper
//                }
//                
//                if let Ra = row["Ra"]?.asDouble() {
//                    //                    print("The Star Ra is \(Ra)")
//                    temp_star.ra = Ra
//                    
//                }
//                
//                
//                if let Dec = row["Dec"]?.asDouble() {
//                    //                    print("The Star Dec is \(Dec)")
//                    
//                    temp_star.dec = Dec
//                }
//                if let Dist = row["Dist"]?.asDouble() {
//                    //println("The Star Dist is \(Dist)")
//                    
//                    temp_star.dist = Dist
//                }
//                
//                if let Mag = row["Mag"]?.asDouble() {
//                    //println("The Star Mag is \(Mag)")
//                    temp_star.mag = Mag
//                    
//                }
//                if let Absmag = row["Absmag"]?.asDouble() {
//                    //println("The Star Absmag is \(Absmag)")
//                    temp_star.absmag = Absmag
//                    
//                }
//                if let Spect = row["Spect"]?.asString() {
//                    //println("The Star Spect is \(Spect)")
//                    
//                    temp_star.spect = Spect
//                }
//                if let X = row["X"]?.asDouble() {
//                    //println("The Star X is \(X)")
//                    temp_star.x = X
//                }
//                
//                if let Y = row["Y"]?.asDouble() {
//                    //println("The Star Y is \(Y)")
//                    
//                    temp_star.y = Y
//                    
//                }
//                if let Z = row["Z"]?.asDouble() {
//                    //println("The Star Z is \(Z)")
//                    
//                    temp_star.z = Z
//                    
//                }
//                
//                
//                if let Bayer = row["Bayer"]?.asString() {
//                    //println("The Star Bayer is \(Bayer)")
//                    
//                    temp_star.bayer = Bayer
//                }
//                if let Flam = row["Flam"]?.asString() {
//                    //println("The Star Flam is \(Flam)")
//                    
//                    temp_star.flam = Flam
//                }
//                if let Con = row["Con"]?.asString() {
//                    //println("The Star Con is \(Con)")
//                    
//                    temp_star.con = Con
//                }
//                
//                
//                if let Lum = row["Lum"]?.asDouble() {
//                    //println("The Star Lum is \(Lum)")
//                    
//                    temp_star.lum = Lum
//                    
//                }
//                
//                if let guanka = row["guanka"]?.asInt() {
//                    //println("The Star Lum is \(Lum)")
//                    
//                    temp_star.guanka = guanka
//                    
//                }
//                
//                if let conid = row["Con_Id"]?.asInt() {
//                    //println("The Star Lum is \(Lum)")
//                    
//                    temp_star.conid = conid
//                }
//                
//                
//                
//                
//                Starlist.append(temp_star)
//                
//                
//                
//                
//            }
//        }
//        //TextView_DisplayAll.text = result
//        
//        return Starlist
//        
//    }
//    
//    
//    
//    
//    
//    
//    func getConstellationByLevel(level: Int) -> Constellation{
//        
//        let con = Constellation()
//        
//        
//        var (resultSet, err) = SD.executeQuery("select * from startrix_2, constellation, starincon where constellation.Con_ID = starincon.Con_ID and starincon.Hd = Startrix_2.Hd and constellation.Con_ID = \(level);")
//        if err != nil {
//            //there was an error during the query, handle it here
//        } else {
//            
//            if let name = resultSet[0]["Name"]?.asString() {
//                //print("The Constellation name is: \(name)")
//                con.name = name
//            }
//            
//            if let category = resultSet[0]["category"]?.asInt() {
//                //print("The Constellation name is: \(name)")
//                con.category = category
//            }
//            
//            if let story = resultSet[0]["story"]?.asString() {
//                //print("The Constellation name is: \(name)")
//                con.story = story
//            }
//            
//            
//            for row in resultSet {
//                
//                let temp_star = Star()
//                
//                if let ID = row["ID"]?.asInt() {
//                    //print("The Star name is: \(ID)")
//                    temp_star.id = ID
//                }
//                
//                if let Hip = row["Hip"]?.asInt() {
//                    //println("The Star Hip is: \(Hip)")
//                    temp_star.hip = Hip
//                }
//                
//                
//                if let Hd = row["Hd"]?.asInt() {
//                    //print("The Star Hd is: \(Hd)")
//                    temp_star.hd = Hd
//                }
//                
//                
//                if let Bf = row["Bf"]?.asString() {
//                    //println("The Star Bf is \(Bf)")
//                    temp_star.bf = Bf
//                }
//                
//                if let Proper = row["Proper"]?.asString() {
//                    //println("The Star Proper is \(Proper)")
//                    
//                    temp_star.proper = Proper
//                }
//                
//                if let Ra = row["Ra"]?.asDouble() {
//                    //print("The Star Ra is \(Ra)")
//                    temp_star.ra = Ra
//                    
//                }
//                
//                
//                if let Dec = row["Dec"]?.asDouble() {
//                    //print("The Star Dec is \(Dec)")
//                    
//                    temp_star.dec = Dec
//                }
//                if let Dist = row["Dist"]?.asDouble() {
//                    //println("The Star Dist is \(Dist)")
//                    
//                    temp_star.dist = Dist
//                }
//                
//                if let Mag = row["Mag"]?.asDouble() {
//                    //println("The Star Mag is \(Mag)")
//                    temp_star.mag = Mag
//                    
//                }
//                if let Absmag = row["Absmag"]?.asDouble() {
//                    //println("The Star Absmag is \(Absmag)")
//                    temp_star.absmag = Absmag
//                    
//                }
//                if let Spect = row["Spect"]?.asString() {
//                    //println("The Star Spect is \(Spect)")
//                    
//                    temp_star.spect = Spect
//                }
//                if let X = row["X"]?.asDouble() {
//                    //println("The Star X is \(X)")
//                    temp_star.x = X
//                }
//                
//                if let Y = row["Y"]?.asDouble() {
//                    //println("The Star Y is \(Y)")
//                    
//                    temp_star.y = Y
//                    
//                }
//                if let Z = row["Z"]?.asDouble() {
//                    //println("The Star Z is \(Z)")
//                    
//                    temp_star.z = Z
//                    
//                }
//                
//                
//                if let Bayer = row["Bayer"]?.asString() {
//                    //println("The Star Bayer is \(Bayer)")
//                    
//                    temp_star.bayer = Bayer
//                }
//                if let Flam = row["Flam"]?.asString() {
//                    //println("The Star Flam is \(Flam)")
//                    
//                    temp_star.flam = Flam
//                }
//                if let Con = row["Con"]?.asString() {
//                    //println("The Star Con is \(Con)")
//                    
//                    temp_star.con = Con
//                }
//                
//                
//                if let Lum = row["Lum"]?.asDouble() {
//                    //println("The Star Lum is \(Lum)")
//                    
//                    temp_star.lum = Lum
//                    
//                }
//                
//                if let guanka = row["guanka"]?.asInt() {
//                    //println("The Star Lum is \(Lum)")
//                    
//                    temp_star.guanka = guanka
//                    
//                }
//                
//                if let conid = row["Con_ID"]?.asInt() {
//                    //println("The Star Lum is \(Lum)")
//                    
//                    temp_star.conid = conid
//                }
//                
//                con.starlist.append(temp_star)
//            }
//        }
//        
//        (resultSet, err) = SD.executeQuery("select * from Line, constellation where Line.Con_ID =constellation.Con_ID AND constellation.Con_ID = \(level); ")
//        
//        if err != nil {
//            //there was an error during the query, handle it here
//        } else {
//            
//            for row in resultSet {
//                
//                
//                
//                let temp_line = Line()
//                
//                
//                
//                if let star1hd = row["StarA_Hd"]?.asInt() {
//                    temp_line.star1hd = star1hd
//                }
//                
//                if let star2hd = row["StarB_Hd"]?.asInt() {
//                    //println("The Star Hip is: \(Hip)")
//                    temp_line.star2hd = star2hd
//                }
//                
//                temp_line.adjust()
//                
//                con.linelist.append(temp_line)
//                
//            }
//        }
//        
//        
//        return con
//        
//    }
//    
//    
//    
//    
    
}

