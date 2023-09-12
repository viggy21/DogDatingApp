//
//  MyEventsTableViewController.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 6/9/22.
//

import UIKit
import Firebase
import FirebaseAuth



class MyEventsTableViewController: UITableViewController, DatabaseListener {
    
    
    
    var listenerType = ListenerType.user // OR EVENT
    weak var databaseController: DatabaseProtocol?
    var usersReference = Firestore.firestore().collection("Users") // This is a reference to the collection of users in Firestore
    var eventsReference = Firestore.firestore().collection("Events")
    var currentUserID: String?
    let SECTION_EVENT = 0
    let CELL_EVENT = "eventCell"
    var myEventsString: [String] = []
    var myEvents: [Event] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Get the current user id
        guard let userID = Auth.auth().currentUser?.uid else {
            // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
            print("Unable to get current user ID - matches view controller")
            return
        }
        currentUserID = userID
        
        let userDocument = self.usersReference.document("\(userID)")
        
        // Reference: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1
        // Some of the code from this reference was used to get the document data from firestore as shown below.
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                // Use dataDescription to populate the different labels (own code)
                if let data = data?["myEvents"] {
                    self.myEventsString = data as? [String] ?? []
                    
                    
                    // Reference: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1
                    // Some of the code from this reference was used to get the document data from firestore as shown below.
                    // For loop to go through all the events and populate myEvents
                    for eventID in self.myEventsString {
                        let eventDocument = self.eventsReference.document(eventID)
                        eventDocument.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                
                                let event = Event()
                                // Use dataDescription to populate the different labels (own code)
                                if let data = data?["name"] {
                                    event.name = data as? String
                                }
                                if let data = data?["creator"] {
                                    event.creator = data as? String
                                }
                                if let data = data?["eventDescription"] {
                                    event.eventDescription = data as? String
                                }
                                if let data = data?["dateAndTime"] {
                                    event.dateAndTime = data as? String
                                }
                                if let data = data?["location"] {
                                    event.location = data as? String
                                }
                                
                                self.myEvents.append(event)
                                print("Appended to my events list: \(event)")
                                
                                // Reload the table view after getting all the data
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_EVENT, for: indexPath) as! EventsListCell

        // Configure the cell...
        let event = myEvents[indexPath.row]
        cell.name.text = event.name
        cell.dateAndTime.text = event.dateAndTime
        cell.eventDescription.text = event.eventDescription
        cell.creator.text = event.creator
        cell.location.text = event.location

        return cell
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
    
    // MARK: - Database listener methods
    func onAuthChange(change: DatabaseChange) {
        
    }
    
    func onUserChange(change: DatabaseChange, userList: [User]) {
        
    }
    
    func onEventChange(change: DatabaseChange, events: [Event]) {
        
    }
    
    func onImageChange(change: DatabaseChange, images: [ImageMetaData]) {
        
    }


   

    
  

   

}
