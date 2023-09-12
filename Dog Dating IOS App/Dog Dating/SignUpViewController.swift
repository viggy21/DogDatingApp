//
//  SignUpViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit
import FirebaseAuth

// For images
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController, DogSizeChangeDelegate, DogPlayChangeDelegate, DogPersonalityChangeDelegate, DogBreedChangeDelegate, ProfilePictureDelegate, FirstPictureDelegate, SecondPictureDelegate, ThirdPictureDelegate {
    
    
    // Reference to firebase data controller
    weak var databaseController: DatabaseProtocol?
    
    // Reference to core data controller
    weak var coreDataDatabaseController: DatabaseProtocol?
    
    // MARK: - Delegate methods for images
    
    // The profilePictureChange function loads the profile picture and sets the image of the profile picture view to the profile picture
    func profilePictureChange(profilePictureFileName: String) {
        // set profilePictureImage as the image using the profilePictureFileName using the fetch particular image method from core data
        let profileImage = loadImageData(filename: profilePictureFileName)
        profilePictureImage.image = profileImage
        print("Accessed the profile picture change method")
        
        
    }
    
    func firstPictureChange(fileName: String) {
        let firstImage = loadImageData(filename: fileName)
        firstPictureImage.image = firstImage
        print("Accessed the first picture change method")
        
    }
    
    func secondPictureChange(fileName: String) {
        let secondImage = loadImageData(filename: fileName)
        secondPictureImage.image = secondImage
        print("Accessed the second picture change method")
        
    }
    
    func thirdPictureChange(fileName: String) {
        let thirdImage = loadImageData(filename: fileName)
        thirdPictureImage.image = thirdImage
        print("Accessed the third picture change method")
        
    }
    
    // Method for loading image data
    func loadImageData(filename: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    
    
   
    
    var errorMessage = ""
    
    
    let ABOUT_DOG_SEGUE = "toAboutDog"
    let ADD_PHOTOS_SEGUE = "addPhotosSegue"
    let DOG_SIZE_SEGUE = "dogSizeSegue"
    let DOG_PERSONALITY_TYPE_SEGUE = "dogPersonalityTypeSegue"
    let DOG_PLAY_STYLE_SEGUE = "dogPlayStyleSegue"
    let DOG_BREED_SEGUE = "dogBreedSegue"
    var email = ""
    var password = ""
    var birthday = ""
    var interests = ""
    var name = ""
    var dogNameVar = ""
    var dogBirthdayVar = ""
    var dogBreedVar = ""
    var dogSizeVar = ""
    var dogPlayStyleVar = ""
    var dogPersonalityTypeVar = ""

    @IBOutlet weak var thirdPictureImage: UIImageView!
    @IBOutlet weak var secondPictureImage: UIImageView!
    @IBOutlet weak var firstPictureImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var dogPersonalityType: UIButton!
    @IBOutlet weak var dogPlayStyle: UIButton!
    @IBOutlet weak var dogSize: UIButton!
    @IBOutlet weak var dogBreed: UIButton!
    @IBOutlet weak var dogBirthday: UIDatePicker!
    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var userInterests: UITextField!
    @IBOutlet weak var userBirthday: UIDatePicker!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // core data
        
        coreDataDatabaseController = appDelegate.coreDataDatabaseController
        //
        // firebase
        databaseController = appDelegate.databaseController
        
        
    }
    
    // MARK: - Next and sign up buttons
    @IBAction func addPhotos(_ sender: Any) {
        // Checking that the relevant fields have been filled in
        guard let dogName = dogName.text, dogName.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter your dog's name")
            return
        }
        dogNameVar = dogName
        
        // Error checking that the birthday entered is not before today's date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Get today's date and time so that we can compare the selected date and time and ensure that it is valid
        let date = Date()
        
        // Compare the current date to the user entered date
        if date.compare(dogBirthday.date) == .orderedAscending {
                displayMessage(title: "Error", message: "Please select a valid date")
        }
        
        // Setting up the dateFormatter for the display of the date
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateStyle = .long

        let dogBirthday = dateFormatterDisplay.string(from: dogBirthday.date) // String of the dog's birthday
        
        
        dogBirthdayVar = dogBirthday
        
        // Checking that the text in the buttons is not the default text
        if dogBreed.titleLabel?.text == "Select Dog Breed" {
            displayMessage(title: "Error", message: "Please select a dog breed")
            
        }
        
        else if dogSize.titleLabel?.text == "Select Dog Size" {
            displayMessage(title: "Error", message: "Please select a dog size")
    
        }
        
        else if dogPlayStyle.titleLabel?.text == "Select Dog Play Style"  {
            displayMessage(title: "Error", message: "Please select a dog play style")
            
        }
        
        else if dogPersonalityType.titleLabel?.text == "Select Dog Personality Type"  {
            displayMessage(title: "Error", message: "Please select a dog personality type")
            
        }
        dogBreedVar = dogBreed.titleLabel?.text ?? ""
        dogSizeVar = dogSize.titleLabel?.text ?? ""
        dogPlayStyleVar = dogPlayStyle.titleLabel?.text ?? ""
        dogPersonalityTypeVar = dogPersonalityType.titleLabel?.text ?? ""
        
        
        performSegue(withIdentifier: ADD_PHOTOS_SEGUE, sender: (Any).self)
        
    }
    
    var tempEvents = [Event]()
    @IBAction func signUpNext(_ sender: Any) {
        // Check that the relevant fields have been filled in
        
        // Create the initial user account before adding the user
        // Check that all fields are filled and that the user email and password is valid
        guard let userEmail = userEmail.text, userEmail.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter a username")
            return
        }
        email = userEmail
        guard let userPassword = userPassword.text, userPassword.isEmpty == false, userPassword.count >= 6 else {
            displayMessage(title: "Error", message: "Please enter a password with at least 6 characters")
            return
        }
        password = userPassword
        guard let userName = userName.text, userName.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter your name")
            return
        }
        name = userName
        // Error checking that the birthday entered is not before today's date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Get today's date and time so that we can compare the selected date and time and ensure that it is valid
        let date = Date()
        
        // Compare the current date to the user entered date
        if date.compare(userBirthday.date) == .orderedAscending {
                displayMessage(title: "Error", message: "Please select a valid date and time")
        }
        
        // Setting up the dateFormatter for the display of the date
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateStyle = .long

        let userBirthday = dateFormatterDisplay.string(from: userBirthday.date) // String of the user's birthday
        
        birthday = userBirthday
        
        guard let userInterests = userInterests.text, userInterests.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter your interests")
            return
        }
        
        interests = userInterests
        
        
        
        if userEmail.contains("@") {
            
            
        }
        else {
            displayMessage(title: "Error", message: "Please enter a valid email")
        }
         
    
        
        
        performSegue(withIdentifier: ABOUT_DOG_SEGUE, sender: (Any).self)
    }
     
    
    // Firestore
    // This is a reference to the collection of users in firestore
    // In this collection, there is a document for each user with their data and each of these user documents will have a collection of images saved and fields for other variables such as their names, birthdays etc..
    var usersReference = Firestore.firestore().collection("Users")
    
    // This property is a reference to Firebase Storage which is where our images are saved to.
    var storageReference = Storage.storage().reference()
    
    var profilePictureString = "profilePicture"
    var firstPictureString = "firstPicture"
    var secondPictureString = "secondPicture"
    var thirdPictureString = "thirdPicture"
    
    // Firebasecontroller sign up method variable
    var currentUser: FirebaseAuth.User?
    
    @IBAction func signUpClicked(_ sender: Any) {
        // Check that all image views contain images to check that users have selected the correct number of images
        if profilePictureImage.image == nil {
            displayMessage(title: "Error", message: "Please select a profile picture")
        }
        if firstPictureImage.image == nil {
            displayMessage(title: "Error", message: "Please select a first picture")
        }
        if secondPictureImage.image == nil {
            displayMessage(title: "Error", message: "Please select a second picture")
        }
        if thirdPictureImage.image == nil {
            displayMessage(title: "Error", message: "Please select a third picture")
        }
        
        
        guard let profileData = profilePictureImage?.image?.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Profile image data could not be compressed")
            return
        }
        guard let firstData = firstPictureImage?.image?.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Profile image data could not be compressed")
            return
        }
        guard let secondData = secondPictureImage?.image?.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Profile image data could not be compressed")
            return
        }
        guard let thirdData = thirdPictureImage?.image?.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Profile image data could not be compressed")
            return
        }
        
        // Reference: https://stackoverflow.com/questions/38352772/is-there-any-way-to-get-firebase-auth-user-uid
        // Used it as an idea of how to access the uid when signing up
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        let authController = Auth.auth()
        Task {
            do {
                let authDataResult = try await authController.createUser(withEmail: email, password: password)
                currentUser = authDataResult.user // this will incude the userID
                
            }
            catch {
                print("User creation failed")
            }
            
            if (currentUser != nil) {
                databaseController?.setupUserListener()
                // Load all the events
                databaseController?.setupEventListener()
                
                // If the user has signed in, we can change the root view controller to the tab bar controller
                // Additional lines from: https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/
                let storyboard = await UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = await storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from our view controller then call the change root view controller function
                // to change to main tab bar
                await (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                
                
                // We need to ensure that we have a valid userID. These are generated automatically for each user and can be obtained through the Firebase Firebase Auth
                guard let userID = Auth.auth().currentUser?.uid else {
                    // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
                    displayMessage(title: "Error", message: "No user logged in!")
                    return
                }
                
                // Uploading the images and the image data to firestore
                self.uploadImage(pictureSelected: profilePictureString, imageData: profileData, userID: userID)
                self.uploadImage(pictureSelected: firstPictureString, imageData: firstData, userID: userID)
                self.uploadImage(pictureSelected: secondPictureString, imageData: secondData, userID: userID)
                self.uploadImage(pictureSelected: thirdPictureString, imageData: thirdData, userID: userID)
                
                // Setting the other user data
                do {
                    try await self.usersReference.document("\(userID)").setData([
                        "name": name,
                        "interests": interests,
                        "birthday": birthday,
                        "dogName": dogNameVar,
                        "dogSize": dogSizeVar,
                        "dogPlayStyle": dogPlayStyleVar,
                        "dogPersonalityType": dogPersonalityTypeVar,
                        "dogBirthday": dogBirthdayVar,
                        "dogBreed": dogBreedVar,
                        "likedEvents": [String](),
                        "myEvents": [String](),
                        "likedUsers": [String](),
                        "dislikedUsers": [String](),
                        "matches": [String]()
                    ])
                } catch {
                    print("User fields were not filled successfully")
                }
                
            }
             
            
        }
       
        
                
    }
    
    func uploadImage(pictureSelected: String, imageData: Data, userID: String) {
        // We need to get a storage reference to a specific file reference in Firebase Storage. This will not yet exist but will be the location of our saved photo once uploaded.
        // The file name for the image name will be userID + pictureSelected e.g. userID + "profilePicture"
        let imageRef = storageReference.child("\(userID)/\(pictureSelected)")
        
        // We need to create a metadata file containing file information to be uploaded.
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Once this is done, we can upload the image to Firebase Storage through an upload task
        let uploadTask = imageRef.putData(imageData, metadata: metadata)
        
        
        // After we start the upload task, we can check if it was a sucess or not. If it was a success, we create a reference to a new document within a user's image collection.
        // The document in the images collection will have the name pictureSelected so it could be profilePicture, firstPicture etc.
        uploadTask.observe(.success) {
            snapshot in
            self.usersReference.document("\(userID)").collection("images").document("\(pictureSelected)").setData(["url" : "\(imageRef)"])
            print("\(pictureSelected) has been uploaded to firestore successfully")
        }
        
        // We need to check to see if any errors occur, if they do, we handle it and print a message to the user
        uploadTask.observe(.failure) {
            snapshot in
            self.displayMessage(title: "Error", message: "\(String(describing: snapshot.error))")
        }
        
    }

     
    
    // Images section
    let PROFILE_PICTURE_SEGUE = "profilePictureSegue"
    let FIRST_PICTURE_SEGUE = "firstPictureSegue"
    let SECOND_PICTURE_SEGUE = "secondPictureSegue"
    let THIRD_PICTURE_SEGUE = "thirdPictureSegue"
    //
    
    // Function for the different segues that will deal with delegation
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DOG_SIZE_SEGUE {
            let destination = segue.destination as! SelectDogSizeTableViewController
            destination.delegate = self
        }
        else if segue.identifier == DOG_PERSONALITY_TYPE_SEGUE {
            let destination = segue.destination as! SelectDogPersonalityTableViewController
            destination.delegate = self
            
        }
        else if segue.identifier == DOG_PLAY_STYLE_SEGUE {
            let destination = segue.destination as! SelectDogPlayStyleTableViewController
            destination.delegate = self
            
        }
        else if segue.identifier == DOG_BREED_SEGUE {
            let destination = segue.destination as! SelectDogBreedTableViewController
            destination.delegate = self
        }
        
        // Instead of doing delegation to show the image, we can just use snapshot listeners and listen for changes in the images which will then update the images
        // Segue for the profile picture image
        else if segue.identifier == PROFILE_PICTURE_SEGUE {
            let destination = segue.destination as! CameraViewController
            destination.profilePictureDelegate = self
            destination.profilePicture = true // letting the camera view controller know that the image button clicked is for the profile picture
            // Setting the properties for the other images to false
            destination.firstPicture = false
            destination.secondPicture = false
            destination.thirdPicture = false
        }
        // Segue for first, second and third picture
        else if segue.identifier == FIRST_PICTURE_SEGUE {
            let destination = segue.destination as! CameraViewController
            destination.firstPictureDelegate = self
            
            destination.firstPicture = true // letting the camera view controller know that the image button clicked is for the first picture
            destination.secondPicture = false
            destination.thirdPicture = false
            destination.profilePicture = false
        }
        
        else if segue.identifier == SECOND_PICTURE_SEGUE {
            let destination = segue.destination as! CameraViewController
            destination.secondPictureDelegate = self
            // letting the camera view controller know that the image button clicked is for the second picture
            destination.firstPicture = false
            destination.secondPicture = true
            destination.thirdPicture = false
            destination.profilePicture = false
        }
        else if segue.identifier == THIRD_PICTURE_SEGUE {
            let destination = segue.destination as! CameraViewController
            destination.thirdPictureDelegate = self
            // letting the camera view controller know that the image button clicked is for the third picture
            destination.firstPicture = false
            destination.secondPicture = false
            destination.thirdPicture = true
            destination.profilePicture = false
        }
        
        // Segue that will pass information to the next view
        else if segue.identifier == ABOUT_DOG_SEGUE {
            let destination = segue.destination as! SignUpViewController
            
            // Setting up the dateFormatter for the display of the date
            let dateFormatterDisplay = DateFormatter()
            dateFormatterDisplay.dateStyle = .long
            let userBirthday = dateFormatterDisplay.string(from: userBirthday.date) // String of the user's birthday
            
            
            destination.email = userEmail.text ?? ""
            destination.password = userPassword.text ?? ""
            destination.birthday = userBirthday
            destination.interests = userInterests.text ?? ""
            destination.name = userName.text ?? ""
            
        }
        else if segue.identifier == ADD_PHOTOS_SEGUE {
            let destination = segue.destination as! SignUpViewController
            // Setting up the dateFormatter for the display of the date
            let dateFormatterDisplay = DateFormatter()
            dateFormatterDisplay.dateStyle = .long

            let dogBirthday = dateFormatterDisplay.string(from: dogBirthday.date) // String of the dog's birthday
            destination.dogBreedVar = dogBreed.titleLabel?.text ?? ""
            destination.dogSizeVar = dogSize.titleLabel?.text ?? ""
            destination.dogPlayStyleVar = dogPlayStyle.titleLabel?.text ?? ""
            destination.dogPersonalityTypeVar = dogPersonalityType.titleLabel?.text ?? ""
            destination.dogNameVar = dogName.text ?? ""
            destination.dogBirthdayVar = dogBirthday
            
            // Pass on the user's email, password etc.
            destination.email = email
            destination.password = password
            destination.birthday = birthday
            destination.interests = interests
            destination.name = name
            
        }
        
    }
    
   
    
    
    func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
   
    
    // MARK: - Delegation methods for dog buttons
    
    // The following are delegate methods used to get the user's selection for their dog's size, play style, personality type and breed.
    /**
     This function returns the dog play style that was chosen by the user.
     The code within the function to change the text of the button was taken from: https://stackoverflow.com/questions/26641571/how-to-change-button-text-in-swift-xcode-6
     */
    /// - Parameters
    /// - dogPlayChosen: The string for the dog play style that was chosen by the user
    func dogPlayChange(dogPlayChosen: String) {
        dogPlayStyle.setTitle(dogPlayChosen, for: .normal)
    }
    
    /**
     This function returns the dog personality type that was chosen by the user.
     The code within the function to change the text of the button was taken from: https://stackoverflow.com/questions/26641571/how-to-change-button-text-in-swift-xcode-6
     */
    /// - Parameters
    /// - dogPersonalityChosen: The string for the dog personality that was chosen by the user
    func dogPersonalityChange(dogPersonalityChosen: String) {
        dogPersonalityType.setTitle(dogPersonalityChosen, for: .normal)
    }
    
    /**
     This function returns the dog breed that was chosen by the user.
     The code within the function to change the text of the button was taken from: https://stackoverflow.com/questions/26641571/how-to-change-button-text-in-swift-xcode-6
     */
    /// - Parameters
    /// - dogBreedChosen: The string for the dog breed that was chosen by the user
    func dogBreedChange(dogBreedChosen: String) {
        dogBreed.setTitle(dogBreedChosen, for: .normal)
    }
    
    // When the dog size is changed/selected, set the text of the button to the dog size
    
    /**
     This function returns the dog size that was chosen by the user.
     The code within the function to change the text of the button was taken from: https://stackoverflow.com/questions/26641571/how-to-change-button-text-in-swift-xcode-6
     */
    /// - Parameters
    /// - dogSizeChosen: The string for the dog size that was chosen by the user
    func dogSizeChange(dogSizeChosen: String) {
        dogSize.setTitle(dogSizeChosen, for: .normal)
    }

}

