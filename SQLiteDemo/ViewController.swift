//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by Pat Murphy on 10/14/17.
//  Copyright © 2017 Pat Murphy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.init()
        let opened = DataManager.dataAccess.openConnection(copyFile: true)
        
        if(opened)
        {
            NSLog("Found SQLite DB")
            
            let dict = ["Password":"123456"]
            let blob : Data = NSKeyedArchiver.archivedData(withRootObject:dict) as Data

            var appInfo = AppInfo(name: "SQLiteDemo", value: "1.0.2", descrip: "unencrypted", date: Date(), blob: blob)
            let status = Models.insertAppInfo(appInfo)
            /*
             //OR you can write it explicitly
            let status = DataManager.dataAccess.executeStatement("insert into AppInfo (name,value,descrip,date,blob) values(?,?,?,?,?)", "SQLiteDemo","1.0.2","unencrypted",Date(),blob)
            */
            if(status)
            {
                NSLog("Insert Ok")
                let results = Models.getAppInfo()
                NSLog("Results = \(results)")
                
                for appInfo in results
                {
                    let value = appInfo.blob
                    if (value?.count)! > 0
                    {
                        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: value! )! as? NSDictionary
                        NSLog("dictionary[\(value!)] = \(dictionary!)")
                    }
                }
            }
            
            //Test Transactions
            var sqlAndParams = [[String:Any]]() //Array of SQL and Params Transactions
            let dict1 = ["Password":"123456"]
            let blob1 : Data = NSKeyedArchiver.archivedData(withRootObject:dict1) as Data
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob1)
            let  sqlParams1 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams1)
            
            let dict2 = ["Password":"789045"]
            let blob2 : Data = NSKeyedArchiver.archivedData(withRootObject:dict2) as Data
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob2)
            let  sqlParams2 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams2)

            let dict3 = ["Password":"456782"]
            let blob3 : Data = NSKeyedArchiver.archivedData(withRootObject:dict3) as Data
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob3)
            let  sqlParams3 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams3)

            let dict4 = ["Password":"876543"]
            let blob4 : Data = NSKeyedArchiver.archivedData(withRootObject:dict4) as Data
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob4)
            let  sqlParams4 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams4)

            let status1 = DataManager.dataAccess.executeTransaction(sqlAndParams)
            if(status1)
            {
                let results = Models.getAppInfo()
                for appInfo in results
                {
                    let value = appInfo.blob
                    if (value?.count)! > 0
                    {
                        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: value! )! as? NSDictionary
                        NSLog("dictionary[\(value!)] = \(dictionary!)")
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

