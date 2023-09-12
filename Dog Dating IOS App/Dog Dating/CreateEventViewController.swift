//
//  CreateEventViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 19/5/2022.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateEventViewController: UIViewController {
    
    var dateAndTimeString: String?
    weak var databaseController: DatabaseProtocol?
    var creator = ""
    // Variables that access firestore
    var usersReference = Firestore.firestore().collection("Users")

    @IBOutlet weak var descriptionEntry: UITextField!
    @IBOutlet weak var locationEntry: UITextField!
    @IBOutlet weak var dateAndTimeEntry: UIDatePicker!
    @IBOutlet weak var nameEntry: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController


    }
    
    @IBAction func createEvent(_ sender: Any) {
        
        
        guard let name = nameEntry.text, name.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter a name")
            return
        }
        
        
        // Date formatting and checking
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Get today's date and time so that we can compare the selected date and time and ensure that it is valid
        let date = Date()
        
        // Compare the current date to the user entered date and show the user an error message if they selected an invalide date (date from the past)
        if date.compare(dateAndTimeEntry.date) == .orderedDescending {
            displayMessage(title: "Error", message: "Please select a valid date and time")
        }
        
        guard let location = locationEntry.text, location.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter a location")
            return
        }
        guard let eventDescription = descriptionEntry.text, eventDescription.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter a description")
            return
        }
        
        // Setting up the dateFormatter for the display of the date
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateStyle = .long
        dateFormatterDisplay.timeStyle = .short

        let userDateAndTime = dateFormatterDisplay.string(from: dateAndTimeEntry.date)
        
        // Getting the user's name
        guard let userID = Auth.auth().currentUser?.uid else {
            // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
            displayMessage(title: "Error", message: "No user logged in!")
            return
        }
        
        let userDocument = self.usersReference.document("\(userID)")
        
        // Reference: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1
        // Some of the code from this reference was used to get the document data from firestore as shown below.
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataTest = document.data()
                if let data = dataTest?["name"] {
                    if let creator = data as? String {
                        // Create the event
                        // We need to add the creator based on the user's name
                        let _ = self.databaseController?.addEvent(creator: creator, dateAndTime: userDateAndTime, eventDescription: eventDescription, location: location, name: name)
                        
                        // Return to the all events page
                        self.navigationController?.popViewController(animated: true)
                        
                        // The following line of code was taken from https://stackoverflow.com/questions/24668818/how-to-dismiss-viewcontroller-in-swift
                        self.dismiss(animated: true, completion: nil)
                        
                }
            }
            
            }
            
        }
            
        
        
        
    }
    
   
    
    /**
     Display message function used to show the user a message
     - This may be placed in another file so that it can be accessed globally
     */
    func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
}
