//
//  AddMedicijnViewController.swift
//  Medicijnkast
//
//  Created by Pieter Stragier on 08/02/17.
//  Copyright © 2017 PWS. All rights reserved.
//

import UIKit
import CoreData


class AddMedicijnViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: - Properties
    
    let segueShowDetail = "SegueFromAddToDetail"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreData = CoreDataStack()

    // MARK: -
    
    @IBOutlet weak var gevondenItemsLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    
    @IBAction func geavanceerdZoeken(_ sender: UIButton) {
    }
    @IBOutlet weak var searchBar: UISearchBar!
    // MARK: -
    
    //private var persistentContainer = NSPersistentContainer(name: "Medicijnkast")
    var sortDescriptorIndex: Int?=nil
    var selectedScopeIndex: Int?=nil
    var searchActive: Bool = false
    // MARK: -
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Medicijn> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Medicijn> = Medicijn.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mpnm", ascending: true)]
        let predicate = NSPredicate(format: "mpnm contains[c] %@", "AlotofMumboJumboblablabla")
        fetchRequest.predicate = predicate
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - View Life Cycle
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("View did disappear!")
        self.appDelegate.saveContext()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Addmedicijn View did load!")
        setUpSearchBar()
        navigationItem.title = "Zoeken"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
 
    // MARK: - share button
    func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Pieter"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    // MARK: - search bar related
    fileprivate func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        
        searchBar.isHidden = false
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["merknaam", "stofnaam", "firmanaam", "alles"]
        searchBar.selectedScopeButtonIndex = -1
        print("Scope: \(searchBar.selectedScopeButtonIndex)")
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }
    
    // MARK: Set Scope
    var filterKeyword = "mpnm"
    var sortKeyword = "mpnm"
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("Scope changed: \(selectedScopeIndex)")
        /* FILTER SCOPE */
        
        switch selectedScope {
        case 0:
            print("scope: merknaam")
            filterKeyword = "mpnm"
        case 1:
            print("scope: stofnaam")
            filterKeyword = "vosnm"
        case 2:
            print("scope: firmanaam")
            filterKeyword = "nirnm"
        case 3:
            print("scope: alles")
            filterKeyword = "alles"
        default:
            filterKeyword = "mpnm"
        }
        var sortKeyword = "mpnm"
        print("filterKeyword: \(filterKeyword)")
        print("searchbar text: \(searchBar.text!)")
        if searchBar.text!.isEmpty == false {
            if filterKeyword == "alles" {
                let subpredicate1 = NSPredicate(format: "mpnm contains[c] %@", searchBar.text!)
                let subpredicate2 = NSPredicate(format: "vosnm contains[c] %@", searchBar.text!)
                let subpredicate3 = NSPredicate(format: "nirnm contains[c] %@", searchBar.text!)
                let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [subpredicate1, subpredicate2, subpredicate3])
                self.fetchedResultsController.fetchRequest.predicate = predicate
                sortKeyword = "mpnm"
            } else {
                let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", searchBar.text!)
                print("predicate: \(predicate)")
                self.fetchedResultsController.fetchRequest.predicate = predicate
                sortKeyword = "\(filterKeyword)"
            }
        } else {
            print("no text in searchBar")
            let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", "AlotofMumboJumboblablabla")
            self.fetchedResultsController.fetchRequest.predicate = predicate
            
            if filterKeyword == "alles" {
                sortKeyword = "mpnm"
            } else {
                sortKeyword = filterKeyword
            }
        }
        
        let sortDescriptors = [NSSortDescriptor(key: "\(sortKeyword)", ascending: true)]
        self.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        do {
            try self.fetchedResultsController.performFetch()
            print("fetching...")
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.tableView.reloadData()
        updateView()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Search should begin editing")
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        /*
        guard !searchText.isEmpty else {
            tableView.reloadData()
            return
        }
        */
        searchActive = true
        // Configure Fetch Request
        /* SORT */
        var sortKeyword = "mpnm"
        
        if self.searchBar.selectedScopeButtonIndex == 3 || searchBar.selectedScopeButtonIndex == -1 {
            if searchBar.text!.isEmpty == true {
                print("scope -1 or 3 and no text in searchBar")
                let predicate = NSPredicate(format: "mpnm contains[c] %@", "AlotofMumboJumboblablabla")
                self.fetchedResultsController.fetchRequest.predicate = predicate
                
            } else {
                let subpredicate1 = NSPredicate(format: "mpnm contains[c] %@", searchText)
                let subpredicate2 = NSPredicate(format: "vosnm contains[c] %@", searchText)
                let subpredicate3 = NSPredicate(format: "nirnm contains[c] %@", searchText)
                let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [subpredicate1, subpredicate2, subpredicate3])
                self.fetchedResultsController.fetchRequest.predicate = predicate
                sortKeyword = "mpnm"
                }
            
        } else {
            if searchBar.text!.isEmpty == true {
                print("scope = 0, 1 or 2 and no text in searchBar")
                let predicate = NSPredicate(format: "mpnm contains[c] %@", "AlotofMumboJumboblablabla")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                if filterKeyword == "alles" {
                let subpredicate1 = NSPredicate(format: "mpnm contains[c] %@", searchText)
                let subpredicate2 = NSPredicate(format: "vosnm contains[c] %@", searchText)
                let subpredicate3 = NSPredicate(format: "nirnm contains[c] %@", searchText)
                let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [subpredicate1, subpredicate2, subpredicate3])
                self.fetchedResultsController.fetchRequest.predicate = predicate
                sortKeyword = "mpnm"
                } else {
                    let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", searchText)
                    print("predicate: \(predicate)")
                    self.fetchedResultsController.fetchRequest.predicate = predicate
                    sortKeyword = "\(filterKeyword)"
                }
            }
        }
        print("filterKeyword: \(filterKeyword)")
        print("searchbar text: \(searchBar.text!)")
        
        
        let sortDescriptors = [NSSortDescriptor(key: "\(sortKeyword)", ascending: true)]
        self.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        print("\(sortKeyword)")
        
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.tableView.reloadData()
        updateView()
        print(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterKeyword = "mpnm"
        sortKeyword = "mpnm"
        print("Cancel clicked")
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
        updateView()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("should end editing")
        
        if searchBar.text!.isEmpty == false {
            let predicate = NSPredicate(format: "\(filterKeyword) contains[c] %@", searchBar.text!)
            print("predicate in should end: \(predicate)")
            self.fetchedResultsController.fetchRequest.predicate = predicate
        } else {
            print("should end and no text in searchBar")
            
            let predicate = NSPredicate(format: "mpnm contains[c] %@", "Alotofmumbojumboblablabla")
            self.fetchedResultsController.fetchRequest.predicate = predicate
        }
        do {
            try self.fetchedResultsController.performFetch()
            print("fetching after should end editing...")
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.tableView.reloadData()
        return true
    }

    // MARK: - Navigation
    let CellDetailIdentifier = "SegueFromAddToDetail"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case CellDetailIdentifier:
            let destination = segue.destination as! MedicijnDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedObject = fetchedResultsController.object(at: indexPath)
            destination.medicijn = selectedObject
            
            //navigationController?.pushViewController(destination, animated: true)
        default:
            print("Unknown segue: \(segue.identifier)")
        }
        
    }

    // MARK: - View Methods
    private func setupView() {
        updateView()
    }
    
    fileprivate func updateView() {
        print("Updating view...")
            

        tableView.isHidden = false
        var x:Int
        if let medicijnen = fetchedResultsController.fetchedObjects {
            x = medicijnen.count
            if x == 0 {
                gevondenItemsLabel.isHidden = true
            } else {
            gevondenItemsLabel.isHidden = false
            }
        } else {
            x = 0
            gevondenItemsLabel.isHidden = true
        }
        self.tableView.reloadData()
        gevondenItemsLabel.text = "\(x)"

        activityIndicatorView.isHidden = true
    }
    
    // MARK: - Notification Handling
    
    func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try CoreDataStack.shared.persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
}

extension AddMedicijnViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
    // MARK: table data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let medicijnen = fetchedResultsController.fetchedObjects else { return 0 }
        print("aantal rijen: \(medicijnen.count)")
        tableView.layer.cornerRadius = 3
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        return medicijnen.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addToMedicijnkast = UITableViewRowAction(style: .normal, title: "Naar Medicijnkast") { (action, indexPath) in
            print("naar medicijnkast")
            // Fetch Medicijn
            let medicijn = self.fetchedResultsController.object(at: indexPath)
            medicijn.setValue(true, forKey: "kast")
            let context = self.coreData.persistentContainer.viewContext
            context.perform {
                do {
                    try context.save()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedKast"), object: nil)
                    print("saved!")
                } catch {
                    print(error.localizedDescription)
                }
                self.appDelegate.saveContext()
            }
        }
        addToMedicijnkast.backgroundColor = UIColor(red: 125/255, green: 0/255, blue:0/255, alpha:1)
        let addToShoppingList = UITableViewRowAction(style: .normal, title: "Naar Aankooplijst") { (action, indexPath) in
            print("naar aankooplijst")
            // Fetch Medicijn
            let medicijn = self.fetchedResultsController.object(at: indexPath)
            medicijn.setValue(true, forKey: "aankoop")
            let context = self.coreData.persistentContainer.viewContext
            do {
                try context.save()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedAankoop"), object: nil)
                print("med saved in aankooplijst")
            } catch {
                print("med not saved in aankooplijst!")
            }
            
        }
        addToShoppingList.backgroundColor = UIColor(red: 85/255, green: 0/255, blue:0/255, alpha:1)
        self.tableView.setEditing(false, animated: true)
        return [addToMedicijnkast, addToShoppingList]
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicijnTableViewCell.reuseIdentifier, for: indexPath) as? MedicijnTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        //cell.backgroundColor = UIColor.blue
        //cell.contentView.backgroundColor = UIColor.purple
        cell.selectionStyle = .none
        
        // Fetch Medicijn
        let medicijn = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1

        cell.mpnm.text = medicijn.mpnm
        cell.mppnm.text = medicijn.mppnm
        cell.vosnm.text = medicijn.vosnm
        cell.nirnm.text = medicijn.nirnm
        
        cell.pupr.text = "Prijs: \((medicijn.pupr?.floatValue)!) €"
        cell.rema.text = "remA: \((medicijn.rema?.floatValue)!) €"
        cell.remw.text = "remW: \((medicijn.remw?.floatValue)!) €"
        cell.cheapest.text = "gdkp: \(medicijn.cheapest.description)"
        
        return cell
    }
    
}
