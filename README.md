# SQLiteDemo
SQLite Demo in Swift using SQLPackage.

## Adding to Your Project
You only need to add SQLPackage to your Xcode Project to use.

It will also add two other packages, Apples Logger, and ObjectMapper, this is done automatically through the package dependencies.
  
To add this package go to Xcode Project 'Info' 'Build Settings' 'Swift Packages' select 'Swift Packages' and hit the '+' button and then enter the URL(git@github.com:pmurphyjam/SQLPackage.git) for this. Xcode should then do the rest for you. There will be three Packages, SQLDataAccess, DataManager, Sqldb, click on all three.

## Adding Codable Models

  The AppInfo.swift struct shows you how to write your Codable Models for your DB. It uses Codable, Sqldb, and ObjectMapper. You need to define 'tableName' and then all the columns in your DB table. The func dbDecode Maps the SQL & PARAMS Dictionary which you get back from SQLDataAccess back to an AppInfo struct for you so your View Controller can consume it.
  
  The Models.swift class creates your SQL functions for AppInfo. InsertAppInfoSQL automatically creates the insert SQL & PARAMS Dictionary for you by using the Sqldb.getSQLInsert() method. The same goes for updateAppInfoSQL. The function Models.getAppInfo reads the DB and returns SQL & PARAMS Dictionary and then Maps this to the AppInfo struct by using dbDecode method, and does this in just 7 lines of code for any structure.
  
  For your App you'll need to create a new AppInfo struct and the equivalent Model for it.
  
  As you can see writing the SQL statements is easy for your Models since SQLDataAccess supports writing the SQL statements directly with simple strings like, 'select * from AppInfo'. You don't need to worry about Preferred Statements and obscure SQLite3 low level C method calls, SQLDataAccess does all that for you, and is battle tested so it doesn't leak memory and uses a queue to sync all your operations so they are guaranteed to complete on the proper thread. SQLDataAccess can run on the back ground thread or the foreground thread without crashing unlike Core Data and Realm. Typically you'll write or insert into your DB on a back ground thread through a Server API using Alamofire and decode the Server JSON using the Codable Model defined in AppInfo.swift. Once your data has been written into SQLite, then just issue a completion event to your View Controller, and then call your View Model which will then consume the data from SQLDataAccess on the foreground thread to display your just updated data in your view controller so it can display it.
  
  An SQL Query for insert is shown below as well as an update, but Sqldb.getSQLInsert() does this for you as does getSQLUpdate().s In addition a SQL Query to determine if the 'value' already exists in 'AppInfo', this Query is useful in determining if you want to do an insert or an update.
  
  When you write your SQL Queries as a String, all the terms that follow are in a variadic argument list of type Any, and your parameters are in an Array. All these terms are separated by commas in your list of SQL arguments. You can enter Strings, Integers, Date’s, and Blobs right after the sequel statement since all of these terms are considered to be parameters for the SQL. The variadic argument array just makes it convenient to enter all your sequel in just one executeStatement or getRecordsForQuery call. If you don’t have any parameters, don’t enter anything after your SQL.

The results array is an Array of Dictionary’s where the ‘key’ is your tables column name, and the ‘value’ is your data obtained from SQLite. You can easily iterate through this array with a for loop or print it out directly or assign these Dictionary elements to custom data object Class that you use in your View Controllers for model consumption. Here in the last Query, appInfo?dbDecode takes the dataArray and turns it into an AppInfo<Array> for you.
  
```swift
    var status:Bool? = false
    //Done by getSQLInsert()
    status = DataManager.executeStatement("insert into AppInfo (name,value,descrip,date,blob) values(?,?,?,?,?)", "SQLiteDemo","1.0.2","unencrypted",Date(),blob)
    
    //Done by getSQLUpdate()
    status = DataManager.executeStatement("update AppInfo set name = ?, value = ?, descrip = ?, date = ?, blob = ? where value = ?","SQLiteDemo","1.0.2","unencrypted",Date(),blob,value)
    
    let dataArray = DataManager.getRecordsForQuery("select value from AppInfo where value = ?",value)
    if(dataArray.count > 0)
    {
       return status!
    }
    
    let appInfo:AppInfo? = AppInfo()
    let dataArray = DataManager.getRecordsForQuery("select * from AppInfo where value = ?",value)
    let resultsArray = appInfo?.dbDecode(dataArray:dataArray as! Array<[String : AnyObject]>)
    return resultsArray!
    
```
  
## Examples for Use
Just follow the code in ViewController.swift to see how to write simple SQL with SQLDataAccess.swift
First you need to name your DB, and then open the SQLite Database your dealing with.

```swift
    DataManager.init()
    DataManager.setDBName(name: "SQLite.db")
    let opened = DataManager.openDBConnection()
```
The SQL DB needs to be in your App Bundle, for SQLiteDemo, it's in Resources/SQLite.db.
If openDBConnection succeeded it found your DB, now you can do a simple insert into Table AppInfo. The above two lines created the DataManager, and copied the SQLite.db to the Documents directory so the App can use it. 
	
```swift
   var appInfo = AppInfo(name: "SQLiteDemo", value: "1.0.2", descrip: "unencrypted", date: Date(), blob: blob)
   let status = Models.insertAppInfo(appInfo)
```

See how simple that was! 

The first line creates an AppInfo Struct, and the next line writes the Struct into the SQLite.db file which now resides in the documents directory.

Now say you want to display it, well that's even easier!

```swift
    let results = Models.getAppInfo()
    print(“results = \(results)”)
```

Yeap that's it, getAppInfo reads the SQLite.db and 'select * from AppInfo' returns an Array of AppInfo structures for you to consume in your view controller.

You can also write the SQL Queries if you choose too, but having the Models.swift do it for you takes advantage of Sqldb extension which creates the inserts and updates for you automatically as long as you define your Codable model properly. 

## SQL Transactions

The ViewController.swift also shows you how to do SQL Transactions. All these are is an Array of SQL Queries that are appended together, and then you execute all of them at once with:

```swift
   let status = DataManager.executeTransaction(sqlAndParams)
```

The advantage of this is you can literally insert 1,000 Objects at once which is exponentially faster than doing individual inserts back to back. This comes in very handy when your Server API returns a hundred JSON objects that need to be saved in your DB quickly. SQLDataAccess spends no more than a few hundred milliseconds writing all that data into the DB, rather than seconds if you were to do them individually.

## Data Types SQLDataAccess Supports

SQLDataAccess will store, ***text, double, float, blob, Date, integer and long long integers***. 

For Blobs you can store ***binary, varbinary, blob.***

For Text you can store ***char, character, clob, national varying character, native character, nchar, nvarchar, varchar, variant, varying character, text***.

For Dates you can store ***datetime, time, timestamp, date.*** No need to convert Dates to Strings and back and forth, SQLDataAccess does all that for you!

For Integers you can store ***bigint, bit, bool, boolean, int2, int8, integer, mediumint, smallint, tinyint, int.***

For Doubles you can store ***decimal, double precision, float, numeric, real, double.*** Double has the most precision.

You can even store Nulls of type ***Null.***

In ViewController.swift a more complex example is done showing how to insert a Dictionary as a 'Blob'. In addition SQLDataAccess understands native Swift Date() so you can insert these objects with out converting, and it will convert them to text and store them, and when retrieved convert them back from text to Date.


In addition all executeStatement and getRecordsForQuery methods can be done with simple String for SQL query and an Array for the parameters needed by the query.
	
```swift
	let sql : String = "insert into AppInfo (name,value,descrip) values(?,?,?)"
	let params : Array = ["SQLiteDemo","1.0.0","unencrypted"]
	let status = DataManager.executeStatement(sql, withParameters: params)
	if(status)
	{
		//Read Table AppInfo into an Array of Dictionaries for the above Transactions
		let results = DataManager.getRecordsForQuery("select * from AppInfo ")
		NSLog("Results = \(results)")
	}
```
## SQLCipher and Encryption
	
In addition SQLDataAccess will also work with SQLCipher, and it's pretty easy to do. To use SQLCipher you must remove 'libsqlite3.tbd' and add 'libsqlcipher-ios.a'. You must also add '-DSQLITE_HAS_CODEC', you then encrypt the Database by calling DataManager.dbEncrypt(key), and you can decrypt it using DataManager.dbDecrypt(). You just set your encryption key, and your done. 

## Battle Tested and High Performance

SQLDataAccess is a very fast and efficient class and guaranteed to not leak memory, and can be used in place of CoreData or Realm which really just uses SQLite as it's underlying data store without all the CoreData integrity fault crashes that come with CoreData. CoreData and Realm need to update their models on the main thread which is a real problem if you're trying to display data in a view controller which is consuming a lot of data at the same time. This means your view controller will become slow and not scroll efficiently for a TableView or CollectionView because it's updating CoreData or Realm Entities. In addition if you do these updates on a background thread Core Data and Realm will crash. SQLDataAccess has none of these threading problems, and you can read or write data on either the background or foreground threads, and it's thread safe and guaranteed to finish an update or insert before it starts another one.

So make your life easier, and all your Apps more reliable, and use SQLDataAccess, and best of all it's free with no license required!
