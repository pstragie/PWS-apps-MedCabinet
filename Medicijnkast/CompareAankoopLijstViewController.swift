//
//  CompareAankoopLijstViewController.swift
//  Medicijnkast
//
//  Created by Pieter Stragier on 23/02/17.
//  Copyright © 2017 PWS. All rights reserved.
//

import UIKit
import CoreData

class CompareAankoopLijstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let localdata = UserDefaults.standard

    var receivedData:Array<Array<String>>? = []
    var slideUpInfoView = UIView()
    var prijsremaRight:Float? = 0.00
    var prijsremaLeft:Float? = 0.00
    var prijzenRight:Dictionary<IndexPath, Dictionary<String,Float>> = [:]
    var prijzenLeft:Dictionary<IndexPath, Dictionary<String,Float>> = [:]
    var altscope: String = "Unit"
    var aankooplijstChanged: Bool = false
    let CellLeftDetailIdentifier = "SegueFromCompareLeftToDetail"
    let CellRightDetailIdentifier = "SegueFromCompareRightToDetail"
    @IBOutlet weak var tableViewLeft: UITableView!
    @IBOutlet weak var tableViewRight: UITableView!
    @IBOutlet weak var vosIndexSwitch: UISegmentedControl!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Distinguish between swipe and touchupinside
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        recognizer.direction = .left
        self.view.addGestureRecognizer(recognizer)
        
        setupLayout()

        navigationItem.title = "Vergelijk"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        do {
            try self.fetchedResultsControllerLeft.performFetch()
            try self.fetchedResultsControllerRight.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.tableViewLeft.bounces = true
        self.tableViewRight.bounces = true
        self.tableViewLeft.reloadData()
        self.tableViewRight.reloadData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print("view will appear")
//         Check if aankooplijst has changed
//         TODO
        
        self.tableViewLeft.reloadData()
        self.tableViewRight.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("view did layout subviews")
        setupSlideUpInfoView()
        checkForDoubles()

        do {
            try self.fetchedResultsControllerLeft.performFetch()
            try self.fetchedResultsControllerRight.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.tableViewRight.reloadData()
        self.tableViewLeft.reloadData()
    }
    // MARK: - swipe Left
    func swipeLeft(recognizer: UISwipeGestureRecognizer) -> Bool {
//        print("swiped left")
        return false
    }
    // MARK: - share button
    func shareTapped() {
        // text to share
        var text = ""
        var productL: Array<String>? = []
        var productR: Array<String>? = []
        var verpakkingL: Array<String>? = []
        var verpakkingR: Array<String>? = []
        var vosL: Array<String>? = []
        var vosR: Array<String>? = []
        var firmaL: Array<String>? = []
        var firmaR: Array<String>? = []
        var toepL: Array<String>? = []
        var toepR: Array<String>? = []
        var prijsL: Array<String>? = []
        var prijsR: Array<String>? = []
        var remgeldAL: Array<String>? = []
        var remgeldAR: Array<String>? = []
        var remgeldWL: Array<String>? = []
        var remgeldWR: Array<String>? = []
        var indexL: Array<String>? = []
        var indexR: Array<String>? = []
        
        // fetch medicijnen op pagina
        let medicijnenLeft = fetchedResultsControllerLeft.fetchedObjects
        let medicijnenRight = fetchedResultsControllerRight.fetchedObjects

        for medL in medicijnenLeft! {
            // Store text left side
            productL?.append(medL.mp!.mpnm!)
            verpakkingL?.append(medL.mppnm!)
            vosL?.append(medL.vosnm_!)
            firmaL?.append(medL.mp!.ir!.nirnm!)
            toepL?.append(Dictionaries().hierarchy(hyr: (medL.mp?.hyr?.hyr)!))
            prijsL?.append(medL.pupr!)
            remgeldAL?.append(medL.rema!)
            remgeldWL?.append(medL.remw!)
            indexL?.append(String(medL.index))
        }

        for medR in medicijnenRight! {
            // Store text left side
            productR?.append(medR.mp!.mpnm!)
            verpakkingR?.append(medR.mppnm!)
            vosR?.append(medR.vosnm_!)
            firmaR?.append(medR.mp!.ir!.nirnm!)
            toepR?.append(Dictionaries().hierarchy(hyr: (medR.mp?.hyr?.hyr)!))
            prijsR?.append(medR.pupr!)
            remgeldAR?.append(medR.rema!)
            remgeldWR?.append(medR.remw!)
            indexR?.append(String(medR.index))
        }

        
        let linksAantal = medicijnenLeft?.count
        for x in 0 ..< linksAantal! {
            // Glue text from left and right together
            text += "\(x+1). Product: \(productL![x])\nVerpakking: \(verpakkingL![x])\nVOS: \(vosL![x]) \nFirma: \(firmaL![x])\nToepassing: \(toepL![x])\nPrijs: \(prijsL![x]) €\nRemgeld A: \(remgeldAL![x]) €\nRemgeld W: \(remgeldWL![x]) €\nIndex \(indexL![x]) c€\n"
            // draw dashed line
            text += "_  _  _  _  _  _  _  _  _  _  _  _  _  _  _\n"
            text += "\(x+1). Product: \(productR![x]) \nVerpakking: \(verpakkingR![x])\nVOS: \(vosL![x]) \nFirma: \(firmaR![x]) \nToepassing: \(toepR![x]) \nPrijs: \(prijsR![x]) €\nRemgeld A: \(remgeldAR![x]) €\nRemgeld W: \(remgeldWR![x]) €\nIndex \(indexR![x]) c€\n"
            // draw dashed line
            text += "___________________________________________\n"
        }
        
        let vc = UIActivityViewController(activityItems: [ text ], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        vc.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo ]
        present(vc, animated: false)
    }
    
    // MARK: - segmented button
    func setupLayout() {
        vosIndexSwitch.setTitle("Unit", forSegmentAt: 0)
        vosIndexSwitch.setTitle("Verpakking", forSegmentAt: 1)
    }
    
    // MARK: - Check for doubles (vosnm_) in aankooplijst en verwittig de gebruiker
    func checkForDoubles() {
        // Fetch en count aankooplijst
        var inAankooplijst: Int = 0
        let fetchReq: NSFetchRequest<MPP> = MPP.fetchRequest()
        let predicate = NSPredicate(format: "userdata.aankooplijst == true")
        fetchReq.predicate = predicate
        do {
            let resultaat = try self.appDelegate.persistentContainer.viewContext.fetch(fetchReq)
            inAankooplijst = resultaat.count
        } catch {
            print("fetching error in calculateCheapestPrice")
        }

        let inCompare = receivedData?[0].count
        if inCompare! < inAankooplijst {
            // Show message
            slideUpAlert()
        }
    }
    // MARK: - Setup slide info view
    func setupSlideUpInfoView() {
        self.slideUpInfoView.isHidden = true
        self.slideUpInfoView=UIView(frame:CGRect(x: 30, y: 0, width: (self.view.bounds.width)-60, height: 160))
        //self.slideUpInfoView.addGestureRecognizer(.init(target: slideUpInfoView, action: #selector(slideUpAlert())))
        self.slideUpInfoView.center.y += view.bounds.height
//        print("setup: \(self.slideUpInfoView.center.y)")
        slideUpInfoView.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        slideUpInfoView.layer.cornerRadius = 8
        slideUpInfoView.layer.borderWidth = 1
        slideUpInfoView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(slideUpInfoView)
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 0, width: self.view.bounds.width-100, height: 160)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "U heeft meerdere medicijnen in uw aankooplijst met dezelde voorschriftnaam.\nEnkel unieke medicijnen worden hier getoond."
        
        label.layer.cornerRadius = 20
        label.textColor = UIColor.white
        self.slideUpInfoView.addSubview(label)
        self.slideUpInfoView.isHidden = false
    }
    
    // MARK: - Show Alert
    func slideUpAlert() {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [.curveEaseIn], animations: {
//            print(self.slideUpInfoView.center.y)
            if self.slideUpInfoView.center.y >= self.view.bounds.height {
                self.slideUpInfoView.center.y -= 200
            } else {
                self.slideUpInfoView.center.y += 200
            }
//            print(self.slideUpInfoView.center.y)
        }, completion: {_ in UIView.animate(withDuration: 0.1, delay: 3.0, animations: {
//            print(self.slideUpInfoView.center.y)
            if self.slideUpInfoView.center.y >= self.view.bounds.height {
                self.slideUpInfoView.center.y -= 200
            } else {
                self.slideUpInfoView.center.y += 200
            }
//            print(self.slideUpInfoView.center.y)
        })}
        )
    }
    
    // MARK: - Text alert
    func openTextAlert() {
        // Create Alert Controller
        let alertCompare = UIAlertController(title: "Dubbele medicijnen", message: "U heeft meerdere medicijnen met dezelfde voorschriftnaam (maar in andere dosis) in uw aankooplijst. Deze vergelijking toont enkele unieke voorschriften.", preferredStyle: UIAlertControllerStyle.alert)
        // Create cancel action
        //let cancelAlert = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        //alertCompare.addAction(cancel9)
        // Create OK Action
        let aankooplijstChangedMessage = UIAlertController(title: "De aankooplijst werd gewijzigd.", message: "Herlaad deze pagina door terug te keren naar de aankooplijst en de vergelijking opnieuw te laden.", preferredStyle: UIAlertControllerStyle.alert)
        let okCompare = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in print("OK")
        }
        alertCompare.addAction(okCompare)
        // Present Alert Controller
        if aankooplijstChanged == false {
            self.present(alertCompare, animated:true, completion:nil)
        } else {
            self.present(aankooplijstChangedMessage, animated: true, completion: nil)
        }
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch vosIndexSwitch.selectedSegmentIndex {
        case 0:
            altscope = "Unit"
        case 1:
            altscope = "VOS"
        default:
            altscope = "Unit"
            break
        }
        
//        print("Altscope changed: \(vosIndexSwitch.selectedSegmentIndex)")
        
        self.tableViewRight.reloadData()
        
    }
    
    // MARK: - Table setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        let objectsLeft = receivedData?[0]
        let objectsRight = receivedData?[1]
        
        if tableView == self.tableViewLeft {
            tableViewLeft.layer.cornerRadius = 3
            tableViewLeft.layer.masksToBounds = true
            tableViewLeft.layer.borderWidth = 1
            count = objectsLeft?.count
        }
        
        if tableView == self.tableViewRight {
            tableViewRight.layer.cornerRadius = 3
            tableViewRight.layer.masksToBounds = true
            tableViewRight.layer.borderWidth = 1
            count = objectsRight?.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:Float = 110.0
        if tableView == self.tableViewLeft {
            height = 110.0
        }
        
        if tableView == self.tableViewRight {
            height = 110.0
        }
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MedicijnTableViewCell?
        let objectsLeft = receivedData?[0]
        let objectsRight = receivedData?[1]
        let objectsRightIndex = receivedData?[2]
        if tableView == self.tableViewLeft {
            //tableViewRight.scrollToRow(at: indexPath, at: .top, animated: true)
            cell = tableView.dequeueReusableCell(withIdentifier: MedicijnTableViewCell.reuseIdentifier, for: indexPath) as? MedicijnTableViewCell
            
            // Filter medicijnen
            let predicate = NSPredicate(format: "mppcv IN %@", objectsLeft!)
            self.fetchedResultsControllerLeft.fetchRequest.predicate = predicate
            
            do {
                try self.fetchedResultsControllerLeft.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }

            cell?.selectionStyle = .none
            // Fetch Medicijn
            let medicijn = fetchedResultsControllerLeft.object(at: indexPath)
            if medicijn.userdata?.aankooplijst == false {
                cell?.layer.backgroundColor = UIColor.gray.cgColor
            } else {
                cell?.layer.backgroundColor = UIColor.white.cgColor
            }
            
            // Layout cell
            cell?.layer.cornerRadius = 3
            cell?.layer.masksToBounds = true
            cell?.layer.borderWidth = 1
            cell?.mpnm.text = medicijn.mp?.mpnm
            cell?.mppnm.text = medicijn.mppnm
            cell?.vosnm.text = medicijn.vosnm_
            cell?.nirnm.text = medicijn.mp?.ir?.nirnm
            cell?.pupr.text = "Prijs: \((medicijn.pupr?.floatValue)!) €"
            cell?.rema.text = "remA: \((medicijn.rema?.floatValue)!) €"
            cell?.remw.text = "remW: \((medicijn.remw?.floatValue)!) €"
            //cell?.cheapest.text = "gdkp: \(medicijn.cheapest.description)"
            cell?.cheapest.text = "index: \(medicijn.index) c€"
        }
        
        if tableView == self.tableViewRight {
            //tableViewLeft.scrollToRow(at: indexPath, at: .top, animated: true)
            cell = tableView.dequeueReusableCell(withIdentifier: MedicijnTableViewCell.reuseIdentifier, for: indexPath) as? MedicijnTableViewCell
            var predicate = NSPredicate(format: "mppcv IN %@", objectsRight!)
            if altscope == "VOS" {
                predicate = NSPredicate(format: "mppcv IN %@", objectsRight!)
            } else {
                predicate = NSPredicate(format: "mppcv IN %@", objectsRightIndex!)
            }
            // Filter medicijnen
            self.fetchedResultsControllerRight.fetchRequest.predicate = predicate

            do {
                try self.fetchedResultsControllerRight.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
            let altmed = self.fetchedResultsControllerRight.object(at: indexPath)
            if altmed.userdata?.aankooplijst == false {
                // Color cell when different
                cell?.layer.backgroundColor = UIColor.green.withAlphaComponent(0.2).cgColor
            }
    
            cell?.selectionStyle = .none
            // Fetch Medicijn
            let medicijn = self.fetchedResultsControllerRight.object(at: indexPath)

            var prijzendict:Dictionary<String,Float> = [:]
            prijsremaRight = medicijn.rema?.floatValue
            prijzendict[medicijn.mppcv!] = prijsremaRight
            prijzenRight[indexPath] = prijzendict

            // Layout cell
            cell?.layer.cornerRadius = 3
            cell?.layer.masksToBounds = true
            cell?.layer.borderWidth = 1
            cell?.mpnm.text = medicijn.mp?.mpnm
            cell?.mppnm.text = medicijn.mppnm
            cell?.vosnm.text = medicijn.vosnm_
            cell?.nirnm.text = medicijn.mp?.ir?.nirnm
            cell?.pupr.text = "Prijs: \((medicijn.pupr?.floatValue)!) €"
            cell?.rema.text = "remA: \((medicijn.rema?.floatValue)!) €"
            cell?.remw.text = "remW: \((medicijn.remw?.floatValue)!) €"
            cell?.cheapest.text = "index: \((medicijn.index)) c€"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == tableViewLeft {
            let origineelMedicijn = self.fetchedResultsControllerLeft.object(at: indexPath)
            if origineelMedicijn.userdata?.aankooplijst == true {
                return false
            }
        }
        if tableView == tableViewRight {
            let altMedicijn = self.fetchedResultsControllerRight.object(at: indexPath)
            if altMedicijn.userdata?.aankooplijst == true {
                return false
            } else {
                return true
            }
        }
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView == tableViewLeft {
            let origineelMedicijn = self.fetchedResultsControllerLeft.object(at: indexPath)
            if origineelMedicijn.userdata?.aankooplijst == true {
                return .none
            }
        }
        if tableView == tableViewRight {
            let altmed = self.fetchedResultsControllerRight.object(at: indexPath)
            let orimed = self.fetchedResultsControllerLeft.object(at: indexPath)
            if altmed == orimed && orimed.userdata?.aankooplijst == true {
                return .none
            }
        }
        return .delete
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var btnArray = [UITableViewRowAction()]
        if tableView == self.tableViewLeft {
            let undoReplace = UITableViewRowAction(style: .normal, title: "Annuleer") { (action, indexPath) in
                // Fetch Origineel Medicijn
                let origineelMedicijn = self.fetchedResultsControllerLeft.object(at: indexPath)
                if origineelMedicijn.userdata?.aankooplijst == false {
                    let context = self.appDelegate.persistentContainer.viewContext
                    self.addUserData(mppcvValue: origineelMedicijn.mppcv!, userkey: "aankooplijst", uservalue: true, managedObjectContext: context)
//                    print("ori: \(String(describing: origineelMedicijn.mppnm))")
                    // Fetch alternative medicijn in aankooplijst
                    let altmedicijn = self.fetchedResultsControllerRight.object(at: indexPath)
//                    print("alt: \(String(describing: altmedicijn.mppnm))")
                    if origineelMedicijn != altmedicijn {
                        self.addUserData(mppcvValue: altmedicijn.mppcv!, userkey: "aankooplijst", uservalue: false, managedObjectContext: context)
                    } else {
                        let cellRight = self.tableViewRight.cellForRow(at: indexPath)
                        cellRight?.layer.backgroundColor = UIColor.white.cgColor
                    }
                    let cell = self.tableViewLeft.cellForRow(at: indexPath)
                    cell?.layer.backgroundColor = UIColor.white.cgColor
                    
                    
                    do {
                        try self.fetchedResultsControllerLeft.performFetch()
                        try self.fetchedResultsControllerRight.performFetch()
                    } catch {
                        let fetchError = error as NSError
                        print("Unable to Perform Fetch Request")
                        print("\(fetchError), \(fetchError.localizedDescription)")
                    }
                    self.tableViewLeft.reloadData()
                    self.tableViewRight.reloadData()
                    // Copy entity data to userdefaults
                    self.copyUserdataToUserdefaults(managedObjectContext: context)
                }
            }
            undoReplace.backgroundColor = UIColor(red: 85/255, green: 0/255, blue:0/255, alpha:0.5)
            btnArray.append(undoReplace)
            
        }
        
        if tableView == self.tableViewRight {
            let replaceInShoppingList = UITableViewRowAction(style: .normal, title: "Naar\naankooplijst") { (action, indexPath) in
                // Fetch Medicijn
                let altmedicijn = self.fetchedResultsControllerRight.object(at: indexPath)
                let context = self.appDelegate.persistentContainer.viewContext
                self.addUserData(mppcvValue: altmedicijn.mppcv!, userkey: "aankooplijst", uservalue: true, managedObjectContext: context)
                
                // Fetch the original medicine in aankooplijst
                let aankoopmedicijn = self.fetchedResultsControllerLeft.object(at: indexPath)
                if aankoopmedicijn != altmedicijn {
                    self.addUserData(mppcvValue: aankoopmedicijn.mppcv!, userkey: "aankooplijst", uservalue: false, managedObjectContext: context)
                } else {
                    let cellRight = self.tableViewRight.cellForRow(at: indexPath)
                    cellRight?.layer.backgroundColor = UIColor.white.cgColor
                }
                let cell = self.tableViewLeft.cellForRow(at: indexPath)
                cell?.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.5).cgColor
                
                do {
                    try self.fetchedResultsControllerLeft.performFetch()
                    try self.fetchedResultsControllerRight.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                self.tableViewLeft.reloadData()
                self.tableViewRight.reloadData()
                // Copy entity data to userdefaults
                self.copyUserdataToUserdefaults(managedObjectContext: context)
                
            }
            replaceInShoppingList.backgroundColor = UIColor(red: 85/255, green: 0/255, blue:0/255, alpha:1)
            btnArray.append(replaceInShoppingList)
            
        }
        return btnArray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("did select \(indexPath.row)")
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case CellLeftDetailIdentifier:
            let destination = segue.destination as! MedicijnDetailViewController
            let indexPath = tableViewLeft.indexPathForSelectedRow!
            let selectedObject = fetchedResultsControllerLeft.object(at: indexPath)
            destination.medicijn = selectedObject
        case CellRightDetailIdentifier:
            let destination = segue.destination as! MedicijnDetailViewController
            let indexPath = tableViewRight.indexPathForSelectedRow!
            let selectedObject = fetchedResultsControllerRight.object(at: indexPath)
            destination.medicijn = selectedObject
        default:
//            print("Unknown segue: \(String(describing: segue.identifier))")
            break
        }
    }
    
    // MARK: - Notification Handling
    
    // MARK: - Fetch Results
    fileprivate lazy var fetchedResultsControllerLeft: NSFetchedResultsController<MPP> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MPP> = MPP.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "vosnm_", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsControllerLeft = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsControllerLeft.delegate = self
        
        return fetchedResultsControllerLeft
    }()
    
    fileprivate lazy var fetchedResultsControllerRight: NSFetchedResultsController<MPP> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MPP> = MPP.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "vosnm_", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsControllerRight = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsControllerRight.delegate = self
        
        return fetchedResultsControllerRight
    }()
    
    func applicationDidEnterBackground(_ notification: Notification) {
        self.appDelegate.saveContext()
    }
    
    // MARK: - Synchronous scrolling behaviour
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(tableViewLeft), scrollView.isDragging {
            let topVisibleIndexPathLeft:IndexPath = self.tableViewLeft.indexPathsForVisibleRows![0]
            tableViewLeft.scrollToRow(at: topVisibleIndexPathLeft, at: .top, animated: true)
            tableViewRight.scrollToRow(at: topVisibleIndexPathLeft, at: .top, animated: true)
        } else if scrollView.isEqual(tableViewRight), scrollView.isDragging {
            let topVisibleIndexPathRight:IndexPath = self.tableViewRight.indexPathsForVisibleRows![0]
            tableViewRight.scrollToRow(at: topVisibleIndexPathRight, at: .top, animated: true)
            tableViewLeft.scrollToRow(at: topVisibleIndexPathRight, at: .top, animated: true)
        }
    }
}

extension CompareAankoopLijstViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewLeft.beginUpdates()
        tableViewRight.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewLeft.endUpdates()
        tableViewRight.endUpdates()

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableViewLeft.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableViewLeft.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            break
//            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
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
    
    func addUserData(mppcvValue: String, userkey: String, uservalue: Bool, managedObjectContext: NSManagedObjectContext) {
        // one-to-one relationship
        // Check if record exists
        let userdata = fetchRecordsForEntity("Userdata", key: "mppcv", arg: mppcvValue, inManagedObjectContext: managedObjectContext)
        if userdata.count == 0 {
//            print("data line does not exist")
            if let newUserData = createRecordForEntity("Userdata", inManagedObjectContext: managedObjectContext) {
                newUserData.setValue(uservalue, forKey: userkey)
                newUserData.setValue(mppcvValue, forKey: "mppcv")
                let mpps = fetchRecordsForEntity("MPP", key: "mppcv", arg: mppcvValue, inManagedObjectContext: managedObjectContext)
                newUserData.setValue(Date(), forKey: "lastupdate")
                for mpp in mpps {
                    mpp.setValue(newUserData, forKeyPath: "userdata")
                }
            }
        } else {
//            print("data line exists")
            for userData in userdata {
                userData.setValue(uservalue, forKey: userkey)
                userData.setValue(mppcvValue, forKey: "mppcv")
                userData.setValue(Date(), forKey: "lastupdate")
            }
        }
    }
    
    // MARK: - Copy to Userdefaults
    func copyUserdataToUserdefaults(managedObjectContext: NSManagedObjectContext) {
        //print("Copying Userdata to localdata")
        // Read entity Userdata values
        let userdata = fetchAllRecordsForEntity("Userdata", inManagedObjectContext: managedObjectContext)
        var medarray: Array<Any> = []
        // Check if Userdefaults exist
        // Store to Userdefaults - Create array and store in localdata under key: mppcv
        // Read array of userdata in localdata
        if localdata.object(forKey: "userdata") != nil {
            //print("userdata exists in localdata")
            medarray = localdata.array(forKey: "userdata")!
        } else {
            //print("userdata does not exist in localdata")
            medarray = [] as [Any]
        }
        
        for userData in userdata {
            //print("userData: ", userData)
            let dict = ["medicijnkast": (userData.value(forKey: "medicijnkast")) as! Bool, "medicijnkastarchief": (userData.value(forKey: "medicijnkastarchief")) as! Bool, "aankooplijst": (userData.value(forKey: "aankooplijst")) as! Bool, "aankooparchief": (userData.value(forKey: "aankooparchief")) as! Bool, "aantal": (userData.value(forKey: "aantal")) as! Int, "lastupdate": (userData.value(forKey: "lastupdate")) as! Date, "mppcv": (userData.value(forKey: "mppcv")) as! String, "restant": (userData.value(forKey: "restant")) as! Int] as [String : Any]
            //print("dict: ", dict)
            
            
            // Add mppcv to array of userdata in localdata
            medarray.append(userData.value(forKey: "mppcv")!)
            localdata.set(medarray, forKey: "userdata")
            localdata.set(dict, forKey: (userData.value(forKey: "mppcv")) as! String)
            //print("saved \(String(describing: userData.value(forKey: "mppcv"))) to localdata")
        }
    }

    // MARK: - fetch all records from Userdata
    private func fetchAllRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
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
}
