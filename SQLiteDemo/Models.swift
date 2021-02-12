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

struct Models  {

    static let SQL             = "SQL"
    static let PARAMS          = "PARAMS"
    
    static var log: Logger
    {
        var logger = Logger(label: "Models")
        logger.logLevel = .debug
        return logger
    }
    
    // MARK: - AppInfo
    static func insertAppInfoSQL(_ obj:AppInfo) -> Dictionary<String,Any>
    {
        //Let Sqldb create the SQL insert syntax for us
        //creates SQL : insert into AppInfo (name,value,descript,date,blob) values(?,?,?,?,?)
        let sqlParams = obj.getSQLInsert()!
        log.debug("insertAppInfoSQL : sqlParams = \(sqlParams) ")
        return sqlParams
    }
    
    @discardableResult static func insertAppInfo(_ obj:AppInfo) -> Bool
    {
        let sqlParams = self.insertAppInfoSQL(obj)
        let status = DataManager.dataAccess.executeStatement(sqlParams[SQL] as! String, withParams: sqlParams[PARAMS] as? Array<Any>)
        return status
    }
    
    static func updateAppInfoSQL(_ obj:AppInfo) -> Dictionary<String,Any>
    {
        //Let Sqldb create the SQL update syntax for us
        //creates SQL : update AppInfo set value = ?, descrip = ?, data = ?, blob = ? where name = ?
        let sqlParams = obj.getSQLUpdate(whereItems:"name")!
        log.debug("updateAppInfoSQL : sqlParams = \(sqlParams) ")
        return sqlParams
    }
    
    @discardableResult static func updateAppInfo(_ obj:AppInfo) -> Bool
    {
        let sqlParams = self.updateAppInfoSQL(obj)
        let status = DataManager.dataAccess.executeStatement(sqlParams[SQL] as! String, withParams: sqlParams[PARAMS] as? Array<Any>)
        return status
    }
    
    static func getAppInfo() -> [AppInfo]
    {
        let obj:AppInfo? = AppInfo()
        let dataArray = DataManager.dataAccess.getRecordsForQuery("select * from AppInfo ")
        let appInfoArray = obj?.dbDecode(dataArray:dataArray as! Array<[String : AnyObject]>)
        return appInfoArray!
    }
    
    static func doesAppInfoExistForName(_ name:String) -> Bool
    {
        var status:Bool? = false
        let dataArray = DataManager.dataAccess.getRecordsForQuery("select name from AppInfo where name = ?",name)
        if (dataArray.count > 0)
        {
            status = true
        }
        return status!
    }
}
