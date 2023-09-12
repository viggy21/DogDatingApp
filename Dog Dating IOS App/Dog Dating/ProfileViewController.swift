//
//  ProfileViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {

    
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var thirdPictureImage: UIImageView!
    @IBOutlet weak var secondPictureImage: UIImageView!
    @IBOutlet weak var firstPictureImage: UIImageView!
    @IBOutlet weak var dogPersonalityType: UILabel!
    @IBOutlet weak var dogPlayStyle: UILabel!
    @IBOutlet weak var dogSize: UILabel!
    @IBOutlet weak var dogBreed: UILabel!
    @IBOutlet weak var dogBirthday: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var interests: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var name: UILabel!
    
    // Cache variables
    var inCache = false
    var nsCache = NSCache<NSString, UIImage>()
    
    
    
    @IBAction func logOut(_ sender: Any) {
        Task{
            do {
                try Auth.auth().signOut()
            } catch {
                print("Log out error: \(error.localizedDescription)")
            }
            navigationController?.popViewController(animated: true)
        }
        
        // Additional lines from: https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/
        // After the user logs out, we chagne the root view controller to the login navigation controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        
        // Calling the change root view controller method to go back to the login screen
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    // Variables that access firestore
    var usersReference = Firestore.firestore().collection("Users")
    
    // This property is a reference to Firebase Storage which is where our images are saved to.
    var storageReference = Storage.storage().reference()
    
    var snapshotListener: ListenerRegistration?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Display all user data
        guard let userID = Auth.auth().currentUser?.uid else {
            // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
            displayMessage(title: "Error", message: "No user logged in!")
            return
        }
        
        let userDocument = self.usersReference.document("\(userID)")
        print(userDocument)
        
        // Reference: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1
        // Some of the code from this reference was used to get the document data from firestore as shown below.
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataTest = document.data()

                // Use dataDescription to populate the different labels (own code)
                if let data = dataTest?["name"] {
                    self.name.text = data as? String
                }
                
                if let data = dataTest?["birthday"] {
                    self.birthday.text = data as? String
                }
                 
                if let data = dataTest?["interests"] {
                    self.interests.text = data as? String
                }
                if let data = dataTest?["dogName"] {
                    self.dogName.text = data as? String
                }
                
                if let data = dataTest?["dogBirthday"] {
                    self.dogBirthday.text = data as? String
                }
                 
                if let data = dataTest?["dogBreed"] {
                    self.dogBreed.text = data as? String
                }
                 
                if let data = dataTest?["dogSize"] {
                    self.dogSize.text = data as? String
                }
                if let data = dataTest?["dogPlayStyle"] {
                    self.dogPlayStyle.text = data as? String
                }
                if let data = dataTest?["dogPersonalityType"] {
                    self.dogPersonalityType.text = data as? String
                }
                // End own code
            } else {
                print("Document does not exist")
            }
            
        
            // Check if the images are saved to cache, if they are then just update the image views, if not, then download the images like below
            // The code for this was taken from: https://programmingwithswift.com/cache-image-with-swift/
            
            if  let profileImage = self.nsCache.object(forKey: "profilePicture") {
                self.profilePictureImage.image = profileImage
            }
            else {
                // Get references to the documents with the images
                // The file name for the image name is userID + pictureSelected e.g. userID + "profilePicture"
                let profileImageURL = self.storageReference.child("\(userID)/profilePicture")
                print("printing profileImageURL: \(profileImageURL)")
                
                // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                profileImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    if let data = data {
                        let pic = UIImage(data: data)
                        self.profilePictureImage.image = pic
                    }
                    
                }
                // Save the image to cache e code for this was taken from: https://programmingwithswift.com/cache-image-with-swift/
                self.nsCache.setObject(UIImage(), forKey: "profilePicture")
                // This link could help in making the profile pic round: https://stackoverflow.com/questions/25587713/how-to-set-imageview-in-circle-like-imagecontacts-in-swift-correctly
            }
            
            
            
            
            let firstImageURL = self.storageReference.child("\(userID)/firstPicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            firstImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.firstPictureImage.image = pic
                }
                
            }
            
            let secondImageURL = self.storageReference.child("\(userID)/secondPicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            secondImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.secondPictureImage.image = pic
                }
                 
            }
            
            let thirdImageURL = self.storageReference.child("\(userID)/thirdPicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            thirdImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.thirdPictureImage.image = pic
                }
                
            }
            
           
        }
        // End reference code
        


         
        
        
    }
    

    
    // MARK: - Prepare for segue

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editProfile" {
            let destination = segue.destination as! EditProfileViewController
            destination.nameString = name.text
            destination.interestsString = interests.text
            destination.dogNameString = dogName.text
            destination.dogSizeString = dogSize.text
            destination.dogPlayStyleString = dogPlayStyle.text
            destination.dogPersonalityTypeString = dogPersonalityType.text
            destination.profilePicture = profilePictureImage.image
            destination.firstPicture = firstPictureImage.image
            destination.secondPicture = secondPictureImage.image
            destination.thirdPicture = thirdPictureImage.image
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
