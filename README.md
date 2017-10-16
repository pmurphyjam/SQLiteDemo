# SQLiteDemo
SQLite Demo using Swift with SQLDataAccess class written in Swift

## Adding to Your Project
You only need three files to add to your project
* SQLDataAccess.swift
* DataConstants.swift
* Bridging-Header.h 
  Bridging-Header must be set in your Xcode's project 'Objective-C Bridging Header' under 'Swift Compiler - General'
  
## Examples for Use
Just follow the code in ViewController.swift to see how to write simple SQL with SQLDataAccess.swift
First you need to open the SQLite Database your dealing with

```swift
    let db = SQLDataAccess.shared
    db.setDBName(name:"SQLite.db")
	let opened = db.openConnection(copyFile:true)
```

If openConnection succeeded, now you can do a simple insert into Table AppInfo 
	
	```swift
    //Insert into Table AppInfo
	let status = db.executeStatement("insert into AppInfo (name,value,descrip,date) values(?,?,?,?)", "SQLiteDemo","1.0.2","unencrypted",Date() as CVarArg)
	if(status)
	{
	    //Read Table AppInfo into an Array of Dictionaries
		let results = db.getRecordsForQuery("select * from AppInfo ")
		NSLog("Results = \(results)")
	}
	```
See how simple that was! 

SQLDataAccess will store, text, double, float, blob, Date, integer and long long integers. 
For Blobs you can store binary, varbinary, blob.
For Text you can store char, character, clob, national varying character, native character, nchar, nvarchar, varchar, variant, varying character, text.
For Dates you can store datetime, time, timestamp, date.
For Integers you can store bigint, bit, bool, boolean, int2, int8, integer, mediumint, smallint, tinyint, int.
For Doubles you can store decimal, double precision, float, numeric, real, double. Double has the most precision.
You can even store Nulls of type Null.

In ViewController.swift a more complex example is done showing how to insert a Dictionary as a 'Blob'. In addition SQLDataAccess 
understands native Swift Date() so you can insert these objects with out converting, and it will convert them to text and store them, 
and when retrieved convert them back from text to Date.

Of course the real power of SQLite is it's Transaction capability. Here you can literally queue up a 400 SQL statements with parameters
and insert them all at once which is really powerful since it's so fast. ViewController.swift also shows you an example of how to do this.
All you're really doing is creating an Array of Dictionaries called 'sqlAndParams', in this Array your storing Dictionaries with two keys
'SQL' for the String sequel statement or query, and 'PARAMS' which is just an Array of native objects SQLite understands for that query. 
Each 'sqlParams' which is an individual Dictionary of sequel query plus parameters is then stored in the 'sqlAndParams' Array. 
Once you've created this array, you just call.
	
	```swift
  	let status = db.executeTransaction(sqlAndParams)
  	if(status)
  	{
  	    //Read Table AppInfo into an Array of Dictionaries for the above Transactions
		let results = db.getRecordsForQuery("select * from AppInfo ")
		NSLog("Results = \(results)")
  	}
	```
In addition all executeStatement and getRecordsForQuery can be done with simple String for SQL query and an Array for the parameters needed by query.
	
	```swift
	let sql : String = "insert into AppInfo (name,value,descrip) values(?,?,?)"
    let params : Array = ["SQLiteDemo","1.0.0","unencrypted"]
    let status = db.ExecuteStatement(sql, WithParameters: params)
    if(status)
  	{
  	    //Read Table AppInfo into an Array of Dictionaries for the above Transactions
		let results = db.getRecordsForQuery("select * from AppInfo ")
		NSLog("Results = \(results)")
  	}
	```
	
An Objective-C version also exists and is called the same SQLDataAccess, so now you can choose to write your sequel in Objective-C or Swift.
In addition SQLDataAccess will also work with SQLCipher, the present code isn't setup yet to work with it, but it's pretty easy to do, and 
and example of how to do this is actually in the Objective-C version of SQLDataAccess.

SQLDataAccess is a very fast and efficient class, and can be used in place of CoreData which really just uses SQLite as it's underlying data
store without all the CoreData core data integrity fault crashes that come with CoreData.
