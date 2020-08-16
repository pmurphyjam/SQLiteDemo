//
//  Models.swift
//  SQLiteDemo
//
//  Created by Pat Murphy on 8/10/20.
//  Copyright © 2020 Pat Murphy. All rights reserved.
//

import Foundation
import Logging
import DataManager

class Models: NSObject {

    static var logger = Logger(label: "Models")
    static let SQL             = "SQL"
    static let PARAMS          = "PARAMS"
    
    // MARK: - AppInfo
    class func insertAppInfoSQL(_ appInfo:AppInfo) -> Dictionary<String,Any>
    {
        //Here we let Sqldb create the SQL insert syntax for us
        let sqlParams = appInfo.getSQLInsert()!
        logger.logLevel = .debug
        logger.debug("Models : insertAppInfoSQL : sqlParams = \(sqlParams) ")
        return sqlParams
    }
    
    @discardableResult class func insertAppInfo(_ appInfo:AppInfo) -> Bool
    {
        let sqlParams = self.insertAppInfoSQL(appInfo)
        let status = DataManager.executeStatement(sqlParams[SQL] as! String, withParams: sqlParams[PARAMS] as? Array<Any>)
        return status
    }
    
    class func updateAppInfoSQL(_ appInfo:AppInfo) -> Dictionary<String,Any>
    {
        let sqlParams = appInfo.getSQLUpdate(whereItems:"name")!
        logger.debug("Models : updateAppInfoSQL : sqlParams = \(sqlParams) ")
        return sqlParams
    }
    
    @discardableResult class func updateAppInfo(_ appInfo:AppInfo) -> Bool
    {
        let sqlParams = self.updateAppInfoSQL(appInfo)
        let status = DataManager.executeStatement(sqlParams[SQL] as! String, withParams: sqlParams[PARAMS] as? Array<Any>)
        return status
    }
    
    class func getAppInfo() -> [AppInfo]
    {
        let appInfo:AppInfo? = AppInfo()
        let dataArray = DataManager.getRecordsForQuery("select * from AppInfo ")
        let appInfoArray = appInfo?.dbDecode(dataArray:dataArray as! Array<[String : AnyObject]>)
        return appInfoArray!
    }
}
