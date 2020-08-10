//
//  AppInfo.swift
//  SQLiteDemo
//
//  Created by Pat Murphy on 8/10/20.
//  Copyright © 2020 Pat Murphy. All rights reserved.
//

import UIKit
import ObjectMapper

struct AppInfo: Codable,Sqldb,Mappable {
    
    //Define tableName for Sqldb required for Protocol
    var tableName : String? = "AppInfo"
    var name : String? = ""
    var value : String? = ""
    var descrip : String? = ""
    var date : Date? = Date()
    var blob : Data?
    //Optional sortAlpha default is false
    var sortAlpha: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
        case descrip = "descrip"
        case date = "date"
        case blob = "blob"
    }
    
    init?(map: Map) {
    }
    
    public mutating func mapping(map: Map) {
        name <- map["name"]
        value <- map["value"]
        descrip <- map["descrip"]
        date <- map["date"]
        blob <- map["blob"]
    }
    
    public func dbDecode(dataArray:Array<[String:AnyObject]>) -> [AppInfo]
    {
        //Maps DB dataArray [SQL,PARAMS] back to AppInfo from a DB select or read
        var array:[AppInfo] = []
        for dict in dataArray
        {
            let appInfo = AppInfo(JSON:dict )!
            array.append(appInfo)
        }
        return array
    }
        
    init (name:String,value:String,descrip:String,date:Date,blob:Data)
    {
        self.name = name
        self.value = value
        self.descrip = descrip
        self.date = date
        self.blob = blob
    }
    
    public init() {
        name = ""
        value = ""
        descrip = ""
        date = Date()
        blob = nil
    }
}

extension AppInfo : CustomStringConvertible
{
    var description : String {

        var description = "\rAppInfo "
        if(name != nil)
        {
            description += "\r: name = \(name!)"
        }
        if(value != nil)
        {
            description += "\r: value = \(value!)"
        }
        if(descrip != nil)
        {
            description += "\r: descrip = \(descrip!)"
        }
        if(date != nil)
        {
            description += "\r: date = \(date!)"
        }
        if(blob != nil)
        {
            description += "\r: blob = \(blob?.count)"
        }
        return description
    }
}
