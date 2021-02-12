//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by Pat Murphy on 10/14/17.
//  Copyright © 2017 Pat Murphy. All rights reserved.
//

import UIKit
import DataManager
import Logging

class ViewController: UIViewController {

    var log: Logger
    {
        var logger = Logger(label: "VCtrl")
        logger.logLevel = .debug
        return logger
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.init()
        DataManager.setDBName(name: "SQLite.db")
        let opened = DataManager.openDBConnection()
        
        if(opened)
        {
            log.debug("Found SQLite DB")
            
            let dict = ["Password":"123456"]
            let blob : Data = try! NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)

            var appInfo = AppInfo(name: "SQLiteDemo", value: "1.0.2", descrip: "unencrypted", date: Date(), blob: blob)
            let status = Models.insertAppInfo(appInfo)
            /*
             //OR you can write it explicitly
            let status = DataManager.dataAccess.executeStatement("insert into AppInfo (name,value,descrip,date,blob) values(?,?,?,?,?)", "SQLiteDemo","1.0.2","unencrypted",Date(),blob)
            */
            if(status)
            {
                log.debug("Insert Ok")
                let results = Models.getAppInfo()
                log.debug("Results = \(results)")
                
                for appInfo in results
                {
                    let value = appInfo.blob
                    if (value?.count)! > 0
                    {
                        let dictionary:NSDictionary? = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value!) as? NSDictionary
                        log.debug("dictionary[\(value!)] = \(dictionary!)")
                    }
                }
            }
            
            //Test Transactions
            var sqlAndParams = [[String:Any]]() //Array of SQL and Params Transactions
            let dict1 = ["Password":"123456"]
            let blob1 : Data = try! NSKeyedArchiver.archivedData(withRootObject: dict1, requiringSecureCoding: true)
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob1)
            let  sqlParams1 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams1)
            
            let dict2 = ["Password":"789045"]
            let blob2 : Data = try! NSKeyedArchiver.archivedData(withRootObject: dict2, requiringSecureCoding: true)
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob2)
            let  sqlParams2 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams2)

            let dict3 = ["Password":"456782"]
            let blob3 : Data = try! NSKeyedArchiver.archivedData(withRootObject: dict3, requiringSecureCoding: true)
            appInfo = AppInfo(name: "SQLIteDemo", value: "1.0.0", descrip: "unencrypted", date: Date(), blob: blob3)
            let  sqlParams3 = Models.insertAppInfoSQL(appInfo)
            sqlAndParams.append(sqlParams3)

            let dict4 = ["Password":"876543"]
            let blob4 : Data = try! NSKeyedArchiver.archivedData(withRootObject: dict4, requiringSecureCoding: true)
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
                        let dictionary:NSDictionary? = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value!) as? NSDictionary
                        log.debug("dictionary[\(value!)] = \(dictionary!)")
                    }
                }
            }
            
            let doesExist = Models.doesAppInfoExistForName("SQLIteDemo")
            log.debug("doesExist = \(doesExist)")
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSubviews()
    }
    
    private func configureSubviews() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.heightAnchor.constraint(equalToConstant: 160),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-16)
        ])
    }
    
    private lazy var titleLabel: UILabel = {
         let view = UILabel()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
         view.numberOfLines = 0
         view.textColor = UIColor.black
         view.lineBreakMode = .byTruncatingTail
         var paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.lineHeightMultiple = 1.07
         paragraphStyle.lineSpacing = 8
         let name = "Look at your Xcode Console Log to see the results."
         let attributedText = NSMutableAttributedString(string: name,
                                                        attributes: [NSAttributedString.Key.kern: 0.25,NSAttributedString.Key.paragraphStyle:paragraphStyle])
         view.attributedText = attributedText
         return view
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

