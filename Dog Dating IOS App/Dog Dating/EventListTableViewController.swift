//
//  EventListTableViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit

class EventListTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
                    return
                }

                if searchText.count > 0 {
                    filteredEvents = allEvents.filter({ (event: Event) -> Bool in
                        return (event.name?.lowercased().contains(searchText) ?? false)
                    })
                } else {
                    filteredEvents = allEvents
                }

                tableView.reloadData()

    }
    
    
    let SECTION_EVENT = 0
    let CELL_EVENT = "eventCell"
    let CREATE_EVENT_SEGUE = "createEventSegue"
    let EVENT_DETAILS_SEGUE = "eventDetails"
    
    var allEvents: [Event] = []
    var filteredEvents: [Event] = []
    
    // Setting the listener type and creating a reference to the databse controller
    var listenerType = ListenerType.events
    weak var databaseController: DatabaseProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Create a search bar for searching through events
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search All Events"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true


        filteredEvents = allEvents
    }
    
    // We need to add this page to the listeners when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    // When the view disappears, we remove this page from the list of listeners
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    

    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_EVENT, for: indexPath) as! EventsListCell

        // Configure the cell...
        let event = filteredEvents[indexPath.row]
        cell.name.text = event.name
        cell.dateAndTime.text = event.dateAndTime
        cell.eventDescription.text = event.eventDescription
        cell.creator.text = event.creator
        cell.location.text = event.location 

        return cell
    }
    


    
    // MARK: - Database listener methods
    func onUserChange(change: DatabaseChange, userList: [User]) {
        
    }
    
   
    
    func onEventChange(change: DatabaseChange, events: [Event]) {
        allEvents = events
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    
    func onAuthChange(change: DatabaseChange) {
        
    }
    
    func onImageChange(change: DatabaseChange, images: [ImageMetaData]) {
        
    }

    
    // MARK: - Segue
    // Perfom segue from the cells to the specific cells
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EVENT_DETAILS_SEGUE {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let controller = segue.destination as! SpecificEventViewController
                controller.event = allEvents[indexPath.row]
            }
        }
    }
    
    
    
    @IBAction func createEvent(_ sender: Any) {
        performSegue(withIdentifier: CREATE_EVENT_SEGUE, sender: Any?.self((Any).self))
    }
}
