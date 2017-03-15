//
//  AppDelegate.swift
//  Medicijnkast
//
//  Created by Pieter Stragier on 08/02/17.
//  Copyright © 2017 PWS. All rights reserved.
//

import UIKit
import CoreData
import Foundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreDataManager = CoreDataManager(modelName: "Medicijnkast")
    var errorHandler: (Error) -> Void = {_ in }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(coreDataManager.managedObjectContext)
        let managedObjectContext = coreDataManager.managedObjectContext
        let fm = FileManager.default
        let appdir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print(appdir)
        
        seedPersistentStoreWithManagedObjectContext(managedObjectContext)
        
                
        do {
            // Save Managed Object Context
            try managedObjectContext.save()
        } catch {
            // Error Handling
            print("Unable to save managed object context.")
        }
        
        
        let navigationBarAppearance = UINavigationBar.appearance()
        
        // Change tint and and bar tint
        navigationBarAppearance.tintColor = UIColor.black
        navigationBarAppearance.barTintColor = UIColor.white
        
        // Change navigation item title color
        let navbarfont = UIFont(name:"San Franciso", size: 21) ?? UIFont.systemFont(ofSize: 21)
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: navbarfont]
        
        let tabBarAppearance = UITabBar.appearance()
        // Change tint and bar tint
        tabBarAppearance.tintColor = UIColor.black.withAlphaComponent(1.0)
        tabBarAppearance.barTintColor = UIColor.white.withAlphaComponent(0.0)
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //print(UserDefaults.standard.value(forKey: "last_update")!)
        // Get file last save date of creation date
        //checkForUpdates()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func seedPersistentStoreWithManagedObjectContext(_ managedObjectContext: NSManagedObjectContext) {
        if seedCoreDataContainerIfFirstLaunch() {
            //destroyPersistentStore()

            //let Entities = ["MP", "MPP", "Sam", "Gal", "Stof", "Hyr", "Ggr_Link", "Ir"]
            let Entities = ["MPP", "Gal", "Ggr_Link", "MP", "Sam", "Stof", "Hyr", "Ir"]
            for entitynaam in Entities {
                //cleanCoreData(entitynaam: entitynaam)
                print(entitynaam)
                loadAllAttributes(entitynaam: entitynaam)
            }
        } else {
            // Check for updates
            /* let Entities = ["MPP"]
             for entitynaam in Entities {
             updateAllAttributes(entitynaam: entitynaam)
             } */
        }

    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Medicijnkast")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("CoreData error \(error), \(error._userInfo)")
                self.errorHandler(error)
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved CoreData error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        //let modelURL = Bundle.main.url(forResource: "Medicijnkast", withExtension: "momd")!
        //return NSManagedObjectModel(contentsOf: modelURL)!
        return self.persistentContainer.managedObjectModel
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.Medicijnkast" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    // Optional
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    
    func seedCoreDataContainerIfFirstLaunch() -> Bool {
        //1
        let previouslyLaunched = UserDefaults.standard.bool(forKey: "previouslyLaunched")
        if !previouslyLaunched {
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
            return true
            
        } else {
            return false
        }
    }


    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let coreData = UIApplication.shared.delegate as! AppDelegate
        return coreData.persistentContainer.viewContext
    }
    
    func loadAllAttributes(entitynaam: String) {
        print("loading attributes...")
        let items = preloadData(entitynaam: entitynaam)
        var readLines: Float = 0.0
        var progressie: Float = 0.0
        let totalLines = Float(items.count)
        for item in items {
            readLines += 1
            progressie = readLines/totalLines
            print("progressie: \(progressie)")
            //print("saveAttributes: \(entitynaam), /(dict)")
            var newdict: Dictionary<String,Any> = [:]
            for (key, value) in item {
                var val: Any?
                let key = key.replacingOccurrences(of: "\"", with: "")
                if value == "true" {
                    val = 1
                } else if value == "false" {
                    val = 0
                } else if value == "" {
                    val = "empty"
                }else {
                    val = value
                }
                newdict[key] = val
            }

            self.saveAttributes(entitynaam: entitynaam, dict: newdict)
        }
    }
    /*
    func updateAllAttributes(entitynaam: String) {
        print("loading attributes...")
        let items = preloadData(entitynaam: entitynaam)
        var readLines: Float = 0.0
        var progressie: Float = 0.0
        let totalLines = Float(items.count)
        for item in items {
            readLines += 1
            progressie = readLines/totalLines
            print("progressie: \(progressie)")
            //print("saveAttributes: \(entitynaam), /(dict)")
            self.updateAttributes(entitynaam: entitynaam, dict: item)
        }
    }
    */
    private func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        return result
    }
    
    private func fetchRecordsForEntity(_ entity: String, key: String, arg: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let predicate = NSPredicate(format: "%K == %@", key, arg)
        fetchRequest.predicate = predicate
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return result
    }
    
    func saveAttributes(entitynaam: String, dict: [String:Any]) {
        let managedObjectContext = coreDataManager.managedObjectContext
        print("saving attributes...")
        
        //let newSam = NSManagedObject(entity: entitySam!, insertInto: managedObjectContext)
        //let newRel = NSManagedObject(entity: entityRel!, insertInto: managedObjectContext)
        
        if entitynaam == "MPP" {
            if let newMPP = createRecordForEntity("MPP", inManagedObjectContext: managedObjectContext) {
                for (key, value) in dict {
                    newMPP.setValue(value, forKey: key)
                }
                newMPP.setValue(Date(), forKey: "createdAt")
            }
        }
        
        if entitynaam == "Sam" {
            if let newSam = createRecordForEntity("Sam", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "mppcv" {
                        recordKey = (value as? String)!
                    }
                    newSam.setValue(value, forKey: key)
                }
                
                let mpps = fetchRecordsForEntity("MPP", key: "mppcv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                
                //let newMPP = mpp?.mutableSetValue(forKey: "sam")
                
                
                newSam.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                for mpp in mpps {
                    newSam.setValue(mpp, forKey: "mpp")
                }
                // Add item to items
                //newMPP?.add(newSam)
            }
        }
        
        if entitynaam == "MP" {
            if let newMP = createRecordForEntity("MP", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "mpcv" {
                        recordKey = (value as? String)!
                    }
                    newMP.setValue(value, forKey: key)
                }
                
                let mpps = fetchRecordsForEntity("MPP", key: "mpcv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                newMP.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                //newMP.setValue(NSSet(object: mpp!), forKey: "mpp")
                // Add item to items
                for mpp in mpps {
                    mpp.setValue(newMP, forKeyPath: "mp")
                }
            }
        }
        
        if entitynaam == "Gal" {
            //cleanCoreData(entitynaam: "Gal")
            if let newGal = createRecordForEntity("Gal", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "galcv" {
                        recordKey = (value as? String)!
                        print(value)
                    }
                    newGal.setValue(value, forKey: key)
                }
                
                let mpps = fetchRecordsForEntity("MPP", key: "galcv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                newGal.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                for mpp in mpps {
                    mpp.setValue(newGal, forKeyPath: "gal")
                }
            }
        }

        if entitynaam == "Hyr" {
            if let newHyr = createRecordForEntity("Hyr", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "hyrcv" {
                        recordKey = (value as? String)!
                    }
                    newHyr.setValue(value, forKey: key)
                }
                
                let mps = fetchRecordsForEntity("MP", key: "hyrcv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                newHyr.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                //newHyr.setValue(NSSet(object: mpp!), forKey: "mp")
                // Add item to items
                for mp in mps {
                    mp.setValue(newHyr, forKeyPath: "hyr")
                }
            }
        }
        if entitynaam == "Ir" {
            if let newIr = createRecordForEntity("Ir", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "ircv" {
                        recordKey = (value as? String)!
                    }
                    newIr.setValue(value, forKey: key)
                }
                
                let mps = fetchRecordsForEntity("MP", key: "ircv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                newIr.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                //newIr.setValue(NSSet(object: mpp!), forKey: "mp")
                // Add item to items
                for mp in mps {
                    mp.setValue(newIr, forKeyPath: "ir")
                }
            }
        }
        if entitynaam == "Stof" {
            if let newStof = createRecordForEntity("Stof", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "stofcv" {
                        recordKey = (value as? String)!
                    }
                    newStof.setValue(value, forKey: key)
                }
                
                let sams = fetchRecordsForEntity("Sam", key: "stofcv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                newStof.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                //newStof.setValue(NSSet(object: mpp!), forKey: "sam")
                // Add item to items
                for sam in sams {
                    sam.setValue(newStof, forKeyPath: "stof")
                }
            }
        }
        if entitynaam == "Ggr_Link" {
            // one-to-one relationship
            if let newGgr = createRecordForEntity("Ggr_Link", inManagedObjectContext: managedObjectContext) {
                var recordKey: String = ""
                for (key, value) in dict {
                    if key == "mppcv" {
                        recordKey = (value as? String)!
                    }
                    newGgr.setValue(value, forKey: key)
                }
                
                let mpps = fetchRecordsForEntity("MPP", key: "mppcv", arg: recordKey, inManagedObjectContext: managedObjectContext)
                
                newGgr.setValue(Date(), forKey: "createdAt")
                // Set Relationship
                //newGgr.setValue(mpp!, forKey: "mpp")
                // Add item to items
                for mpp in mpps {
                    mpp.setValue(newGgr, forKeyPath: "ggr_link")
                }
            }
        }

        do {
            try managedObjectContext.save()
            print("context saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: - CSV Parsing
    func parseCSV2Dict (keys: [String], values: [[String]]) -> [Dictionary<String,String>] {
        print("CSV to dictionary")
        
        //print("keys ok: \(keys)")
        //print("values ok: \(values)")
        var items = [Dictionary<String,String>]()
        for v in values {
            var subd = [String:String]()
            for val in 0..<v.endIndex {
                //print("\(keys[val]) : \(v[val])")
                subd[keys[val].lowercased()] = v[val]
            }
            items.append(subd)
        }
        //print("items: \(items)")
        return items
    }
    
    func parseCSV (contentsOf: NSURL, encoding: String.Encoding, error: NSErrorPointer) -> [(Array<String>,Array<Array<String>>)]? {
        // Load the CSV file and parse it
        
        print("Loading CSV file...")
        let delimiter = ";"
        //let content = "(contentsOf: contentsOf, encoding: encoding, error: error)"
        var keys = [String]()
        var lines = [String]()
        var items = [[String]]()
        
        
        do {
            lines = try String(contentsOf: contentsOf as URL, encoding: encoding).components(separatedBy: NSCharacterSet.newlines)
        } catch {
            print("Error reading line.")
        }
        
        for line in lines[0...0] {
            keys = line.components(separatedBy: ";")
        }
        
        for line in lines[1..<lines.endIndex] {
            var values:[String] = []
            //print("line: \(line)")
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.range(of: "\"") != nil {
                    //print(line)
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != "" {
                        
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }
                        
                        // Store the value into the values array
                        
                        values.append(value as! String)
                        
                        
                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.characters.count {
                            textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.components(separatedBy: delimiter)
                    
                }
                // Put the values into a dictionary and add it to the items dictionary
                //print(values)
                items.append(values)
                
            }
        }
        //print("parsing: \([(keys, items)])")
        return [(keys, items)]
    }


    // MARK: Preload all data from csv file
    func preloadData (entitynaam: String) -> [Dictionary<String,String>] {
        
        // Store date to track updates
        UserDefaults.standard.setValue(Date(), forKey: "last_update")
        let filename = entitynaam + "_swift"
        var items:[Dictionary<String,String>] = [[:]]
        print("Preloading data...")
        // Retrieve data from the source file 
        //let d = ["MP":"MP.csv", "MPP":"MPP.csv", "Sam":"Sam.csv", "Stof":"Stof.csv", "Gal":"Gal.csv", "Ggr_Link":"Ggr_Link.csv", "Hyr":"Hyr.csv", "Ir":"Ir.csv"
        //if let remoteURL = NSURL(string: "https://medcabinet.byethost7.com/csv/nl/\(entitynaam).csv") {
        if let path = Bundle.main.path(forResource: filename, ofType: "csv") {
            let contentsOfURL = NSURL(fileURLWithPath: path)
            //print(remoteURL)
            // Remove all entity items before preloading
            
            
            var error:NSError?
            //parseCSV -> [Dictionary<String,String>]
            //if let values = parseCSV(contentsOf: remoteURL, encoding: String.Encoding.utf8, error: &error) {
            if let values = parseCSV(contentsOf: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                print("parsing data successful...")
                //item -> Dictionary<String,String>
                let keys = values[0].0
                //print("keys: \(keys)")
                let val = values[0].1
                //print("val: \(val)")
                items = parseCSV2Dict(keys: keys, values: val) /* items = list of dictionaries */
                                
            } else {
                print("Parsing of data failed")
            }
        } else {
            print("File not found!")
        }
        return items
    }
    
    /*
    func destroyPersistentStore() {
        let fileManager = FileManager.default
        let storeName = "Medicijnkast.sqlite"
        print("Destroying persistent store!")
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        do {
            try coreDataManager.persistentStoreCoordinator.destroyPersistentStore(at: persistentStoreURL, ofType: NSSQLiteStoreType, options: nil)
        
        } catch {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
    }
    */
    func cleanCoreData(entitynaam: String) {
        // Remove the existing items
        print("Cleaning core data... \(entitynaam)")
        let context = viewContext
        /*
        var list: NSManagedObject? = nil
        let lists = fetchRecordsForEntity(entitynaam, inManagedObjectContext: context)
        if let listRecord = lists.first {
            list = listRecord
        }
        
        let items = list?.mutableSetValue(forKey: "sam")
        if let anyItem = items?.anyObject() as? NSManagedObject {
            context.delete(anyItem)
            print("AnyItem deleted")
        } else {
            context.delete(list!)
            print("List deleted")
        }
        saveContext()
        */
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entitynaam)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            print("deleting all contents...")
            try context.execute(deleteRequest)
            //try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch {
            print(error.localizedDescription)
            print("Deleting Core Data failed!")
            fatalError("Failed to execute request: \(error)")
        }
        
        /*
        if let result = try? context.fetch(fetch) {
            for object in result {
                context.delete(object as! NSManagedObject)
            }
        }
        */
        
    }
    
    // MARK: Remove all Data from Medicijn before adding the parsed data.
    func cleanCoreDataMedicijn() {
        print("Cleaning core data...")
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MPP> = MPP.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all contents...")
            try context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    /*
    // Check for updates
    private func checkForUpdates() {
        var fileModificationDate:Date?
        var attributes:Dictionary<FileAttributeKey,Any> = [:]
        let path = Bundle.main.path(forResource: "combinednoempties", ofType: "csv")
        let fileManager = FileManager.default
        do {
            attributes = try fileManager.attributesOfItem(atPath: path!)
        } catch {
            print("Could not get file.")
        }
        fileModificationDate = attributes[FileAttributeKey.modificationDate]! as? Date
        if fileModificationDate! > UserDefaults.standard.value(forKey: "last_update") as! Date {
            print("jonger.")
            // Update needed
            updateCoreData()
        } else {
            // Temporarily, delete once it works
            updateCoreData()
            print("ouder of even oud.")
        }

    }
    // Update core data
    
    private func updateCoreData() {
        let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
        
        // Helpers
        //var list: NSManagedObject? = nil
        
        // Fetch List Records
        //let lists = fetchRecordsForEntity("Medicijn", inManagedObjectContext: managedObjectContext) // Array<NSManagedObject>
        // Get csv data
        print("Fetching csv data...")
        // Get csv data and store in list of dictionaries
        let medicijnen = preloadData(entitynaam: "MP") // [Dictionary<String,String>]
        // Read every dictionary
        for medicijn in medicijnen {
            for (key, value) in medicijn {
                if key == "update" && value == "true" {
                    let predicate = NSPredicate(format: "mppcv == %@", medicijn["mppcv"]!)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Medicijn")
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchedEntities = try managedObjectContext.execute(fetchRequest)
                        print("found changed record: \(medicijn["mppcv"])")
                        var ambvalue:NSNumber?
                        var btvalue:NSNumber?
                        var hospvalue:NSNumber?
                        var cheapestvalue:NSNumber?
                        var narcoticvalue:NSNumber?
                        var orphanvalue:NSNumber?
                        var specrulesvalue:NSNumber?
                        var updatevalue:NSNumber?
                        var pipvalue:NSNumber?
                        
                        if medicijn["amb"] == "true" {
                            ambvalue = 1
                        } else {
                            ambvalue = 0
                        }
                        if medicijn["bt"] == "true" {
                            btvalue = 1
                        } else {
                            btvalue = 0
                        }
                        if medicijn["hosp"] == "true" {
                            hospvalue = 1
                        } else {
                            hospvalue = 0
                        }
                        if medicijn["cheapest"] == "true" {
                            cheapestvalue = 1;
                        } else {
                            cheapestvalue = 0
                        }
                        if medicijn["narcotic"] == "true" {
                            narcoticvalue = 1
                        } else {
                            narcoticvalue = 0
                        }
                        if medicijn["orphan"] == "true" {
                            orphanvalue = 1
                        } else {
                            orphanvalue = 0
                        }
                        if medicijn["specrules"] == "true" {
                            specrulesvalue = 1
                        } else {
                            specrulesvalue = 0
                        }
                        if medicijn["update"] == "true" {
                            updatevalue = 1
                        } else {
                            updatevalue = 0
                        }
                        if medicijn["pip"] == "true" {
                            pipvalue = 1
                        } else {
                            pipvalue = 0
                        }
                        fetchedEntities.setValue(ambvalue, forKey: "amb")
                        fetchedEntities.setValue(btvalue, forKey: "bt")
                        fetchedEntities.setValue(cheapestvalue, forKey: "cheapest")
                        fetchedEntities.setValue(medicijn["galcv"], forKey: "galcv")
                        fetchedEntities.setValue(medicijn["galnm"], forKey: "galnm")
                        fetchedEntities.setValue(hospvalue, forKey: "hosp")
                        fetchedEntities.setValue(medicijn["hyrcv"], forKey: "hyrcv")
                        fetchedEntities.setValue(medicijn["index"], forKey: "index")
                        fetchedEntities.setValue(medicijn["inncnk"], forKey: "inncnk")
                        fetchedEntities.setValue(medicijn["intro"], forKey: "intro")
                        fetchedEntities.setValue(medicijn["ircv"], forKey: "ircv")
                        fetchedEntities.setValue(medicijn["law"], forKey: "law")
                        fetchedEntities.setValue(medicijn["link2mpg"], forKey: "link2mpg")
                        fetchedEntities.setValue(medicijn["link2pvt"], forKey: "link2pvt")
                        fetchedEntities.setValue(medicijn["mpcv"], forKey: "mpcv")
                        fetchedEntities.setValue(medicijn["mpnm"], forKey: "mpnm")
                        fetchedEntities.setValue(medicijn["mppnm"], forKey: "mppnm")
                        fetchedEntities.setValue(narcoticvalue, forKey: "narcotic")
                        fetchedEntities.setValue(medicijn["nirnm"], forKey: "nirnm")
                        fetchedEntities.setValue(medicijn["ninnm"], forKey: "ninnm")
                        fetchedEntities.setValue(medicijn["note"], forKey: "note")
                        fetchedEntities.setValue(medicijn["ogc"], forKey: "ogc")
                        fetchedEntities.setValue(orphanvalue, forKey: "orphan")
                        fetchedEntities.setValue(pipvalue, forKey: "pip")
                        fetchedEntities.setValue(medicijn["ppgal"], forKey: "ppgal")
                        fetchedEntities.setValue(medicijn["pupr"], forKey: "pupr")
                        fetchedEntities.setValue(medicijn["rema"], forKey: "rema")
                        fetchedEntities.setValue(medicijn["remw"], forKey: "remw")
                        fetchedEntities.setValue(specrulesvalue, forKey: "specrules")
                        fetchedEntities.setValue(medicijn["spef"], forKey: "spef")
                        fetchedEntities.setValue(medicijn["ssecr"], forKey: "ssecr")
                        fetchedEntities.setValue(medicijn["stofcv"], forKey: "stofcv")
                        fetchedEntities.setValue(medicijn["stofnm"], forKey: "stofnm")
                        fetchedEntities.setValue(medicijn["ti"], forKey: "ti")
                        fetchedEntities.setValue(medicijn["use"], forKey: "use")
                        fetchedEntities.setValue(medicijn["volgnr"], forKey: "volgnr")
                        fetchedEntities.setValue(medicijn["vosnm"], forKey: "vosnm")
                        fetchedEntities.setValue(medicijn["wadan"], forKey: "wadan")
                        fetchedEntities.setValue(updatevalue, forKey: "update")
                        fetchedEntities.setValue(Date(), forKey: "updatedAt")

                    } catch {
                        print("fetching failed, new record?")
                        saveAttributes(dict: medicijn)
                    }
                }
            }
        }
        
        
        do {
            // Save Managed Object Context
            try managedObjectContext.save()
        } catch {
            print("Unable to save managed object context")
        }

    }
 
    // Existing installation with existing data - check for updates
    private func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        return result
    }
    
    private func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
     */
}

extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
    var stringValue: String? {
        return String(self)
    }
    var boolValue: Bool? {
        return Bool(self)
    }
}
