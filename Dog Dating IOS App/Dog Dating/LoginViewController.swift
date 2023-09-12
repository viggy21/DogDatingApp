//
//  LoginViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

// CALL THE LOGOUT METHOD WHEN THE BACK BUTTON IS PRESSED OR SMTH



import UIKit
import FirebaseAuth
import MessageKit

class LoginViewController: UIViewController  {
    
    
    // Message code starts here
    var currentSender: Sender?
    // Message code ends here
    
    
    
    var authHandle: AuthStateDidChangeListenerHandle?
    let loginSegue = "loginSegue"
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func loginAction(_ sender: Any) {
        
        guard let password = password.text, password.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }
        guard let username = username.text, username.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter a username")
            return
        }
        if username.contains("@") {
            let _ = databaseController?.loggingIn(email: username, password: password)
        }
        else {
            displayMessage(title: "Error", message: "Please enter a valid email")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // When the view appears we need to attach a listener to Firebase Authentication
        authHandle = Auth.auth().addStateDidChangeListener() {
            (auth, user) in
            // We check if the user exists and if it doesn, then we perform a segue to the next screen
            guard user != nil else {return}
            self.performSegue(withIdentifier: self.loginSegue, sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let authHandle = authHandle else {
            return
        }
        Auth.auth().removeStateDidChangeListener(authHandle)
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
