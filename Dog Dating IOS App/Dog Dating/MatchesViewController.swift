//
//  MatchesViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 28/4/2022.
//

import UIKit
import Firebase
import CoreMotion

class MatchesViewController: UIViewController, DatabaseListener {
    
    
    var userList = [User]()
    var likedList = [String]()
    var dislikedList = [String]()
    var currentUserID: String?
    var displayedUser: User?
    var currentUser: User?
    var listenerType = ListenerType.user
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var filledLikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var thirdPictureImage: UIImageView!
    @IBOutlet weak var secondPictureImage: UIImageView!
    @IBOutlet weak var dogPersonalityType: UILabel!
    @IBOutlet weak var dogPlayStyle: UILabel!
    @IBOutlet weak var dogSize: UILabel!
    @IBOutlet weak var dogBreed: UILabel!
    @IBOutlet weak var dogBirthday: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var firstPictureImage: UIImageView!
    @IBOutlet weak var interests: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    func onAuthChange(change: DatabaseChange) {
        
    }
    

    func onUserChange(change: DatabaseChange, userList: [User]) {
        // Hide the filled button and show the unfilled button
        filledLikeButton.isHidden = true
        likeButton.isHidden = false
        
        self.userList = userList
        
        
        guard let userID = Auth.auth().currentUser?.uid else {
            // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
            print("Unable to get current user ID - matches view controller")
            return
        }
        currentUserID = userID
        var usersReference = Firestore.firestore().collection("Users") // This is a reference to the collection of users in Firestore
        
        // Get the list of the user's liked and disliked users
        // Reference: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1
        // Some of the code from this reference was used to get the document data from firestore as shown below.
        if let currentUserID = currentUserID {
            var currentUserRef = usersReference.document(currentUserID)
            currentUserRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data?["likedUsers"] {
                        if let likedUsersData = data as? [String] {
                            self.likedList = likedUsersData
                        }
                    }
                    if let data = data?["dislikedUsers"] {
                        if let dislikedUsersData = data as? [String] {
                            self.dislikedList = dislikedUsersData
                        }
                    }
                }
            }
        }
        
        // Check the user's list of matches and show a match then add that match to the user's liked or disliked user list when they list or dislike the user
        // Whenever there's a change in the users, this method will be called so we will be able to loop through all the different unmatched users.
        for user in userList {
            if let userID = user.id {
                if !likedList.contains(userID), !dislikedList.contains(userID), currentUserID != userID {
                    displayUser(user: user)
                    // Break statement from: https://www.programiz.com/swift-programming/break-statement#:~:text=The%20break%20statement%20is%20used,immediately%20when%20it%20is%20encountered.
                    // Use the break statement because we have already found the user we want to display
                    break
                }
            }
        }
        
    }
    
    func onEventChange(change: DatabaseChange, events: [Event]) {
        
    }
    
    func onImageChange(change: DatabaseChange, images: [ImageMetaData]) {
        
    }
    
    
    
    
    var usersReference = Firestore.firestore().collection("Users") // This is a reference to the collection of users in Firestore
    // This property is a reference to Firebase Storage which is where our images are saved to.
    var storageReference = Storage.storage().reference()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Get the current user id
        guard let userID = Auth.auth().currentUser?.uid else {
            // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
            print("Unable to get current user ID - matches view controller")
            return
        }
        currentUserID = userID
        
        // Hide the filled button and show the unfilled button
        filledLikeButton.isHidden = true
        likeButton.isHidden = false
        
    }
    
    func displayUser(user: User) {
        displayedUser = user
        
        name.text = user.name
        birthday.text = user.birthday
        interests.text = user.interests
        dogName.text = user.dogName
        dogBirthday.text = user.dogBirthday
        dogBreed.text = user.dogBreed
        dogSize.text = user.dogSize
        dogPlayStyle.text = user.dogPlayStyle
        dogPersonalityType.text = user.dogPersonalityType
        
        // Displaying the images
        // Get references to the documents with the images
        // The file name for the image name is userID + pictureSelected e.g. userID + "profilePicture"
        if let displayUserID = user.id {
            let profileImageURL = self.storageReference.child("\(displayUserID)/profilePicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            profileImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.profilePictureImage.image = pic
                    print("printing profile url")
                    print(profileImageURL)
                }
                
            }
            
            let firstImageURL = self.storageReference.child("\(displayUserID)/firstPicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            firstImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.firstPictureImage.image = pic
                    print("printing first image url")
                    print(firstImageURL)
                }
                
            }
            
            let secondImageURL = self.storageReference.child("\(displayUserID)/secondPicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            secondImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.secondPictureImage.image = pic
                    print("printing second url")
                    print(secondImageURL)
                }
                
            }
            
            let thirdImageURL = self.storageReference.child("\(displayUserID)/thirdPicture")
            
            // The code from https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift was copied to get image data from Firebase
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            thirdImageURL.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    self.thirdPictureImage.image = pic
                    print("printing third url")
                    print(thirdImageURL)
                }
                
            }
        
        }
        
    }
    
    @IBAction func dislike(_ sender: Any) {
        // Add the shown user to the user's disliked users list
        if let currentUserID = currentUserID, let displayedUser = displayedUser {
            let _ = databaseController?.addUserToUserDisliked(dislikedUser: displayedUser, currentUserID: currentUserID)
         
        }

         
    }
    
    
    
    @IBAction func like(_ sender: Any) {
        // Show the filled button and hide the unfilled button
        likeButton.isHidden = true
        filledLikeButton.isHidden = false
        
        
        // Add the shown user to the user's liked users list
        if let currentUserID = currentUserID, let displayedUser = displayedUser {
            let _ = databaseController?.addUserToUserLiked(likedUser: displayedUser, currentUserID: currentUserID)
        
        }
        
        
         
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

    
    // Adding the swipe gestures -> swiping left means disliking a user and swiping right means liking a user
    let motionManager: CMMotionManager = CMMotionManager()
    @IBAction func handleSwipe(_ sender: Any) {
        guard let recognizer = sender as? UISwipeGestureRecognizer else {
            return
        }
        if recognizer.direction == .left {
            // Add the shown user to the user's disliked users list
            if let currentUserID = currentUserID, let displayedUser = displayedUser {
                let _ = databaseController?.addUserToUserDisliked(dislikedUser: displayedUser, currentUserID: currentUserID)
             
            }
            
        } else if recognizer.direction == .right {
            // Show the filled button and hide the unfilled button
            likeButton.isHidden = true
            filledLikeButton.isHidden = false
            
            
            // Add the shown user to the user's liked users list
            if let currentUserID = currentUserID, let displayedUser = displayedUser {
                let _ = databaseController?.addUserToUserLiked(likedUser: displayedUser, currentUserID: currentUserID)
            
            }
        }

    }
}
