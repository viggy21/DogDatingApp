//
//  CameraViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 4/5/2022.
//



import UIKit


import Firebase
import FirebaseStorage
import CoreData



class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Properties for image delegation
    weak var profilePictureDelegate: ProfilePictureDelegate?
    weak var firstPictureDelegate: FirstPictureDelegate?
    weak var secondPictureDelegate: SecondPictureDelegate?
    weak var thirdPictureDelegate: ThirdPictureDelegate?
    var profilePicture: Bool?
    var firstPicture: Bool?
    var secondPicture: Bool?
    var thirdPicture: Bool?
    var profilePictureString = "profilePicture"
    var firstPictureString = "firstPicture"
    var secondPictureString = "secondPicture"
    var thirdPictureString = "thirdPicture"
    
    
    
    weak var coreDataDatabaseController: DatabaseProtocol?
    
    // Firestore
    // This is a reference to the collection of users in firestore
    // In this collection, there is a document for each user with their data and each of these user documents will have a collection of images saved.
    var usersReference = Firestore.firestore().collection("Users")
    
    // This property is a reference to Firebase Storage which is where our images are saved to.
    var storageReference = Storage.storage().reference()

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = imageView.image else {
            displayMessage(title: "Error", message: "Cannot save until an image has been selected!")
            return
        }
        
        // Based on delegation, check if the segue to this controller is through selecting the profile picture, first or second picture. Then, based on that (using if else), name the file profilePicture.jpg, firstPicture.jpg etc.
        var filename = ".jpg"
        let timestamp = UInt(Date().timeIntervalSince1970)
        var pictureSelected = ""
        if profilePicture == true {
            filename = profilePictureString+filename
            pictureSelected = profilePictureString
            print(filename)
        }
        else if firstPicture == true {
            filename = firstPictureString+filename
            pictureSelected = firstPictureString
            print(filename)
        }
        else if secondPicture == true {
            filename = secondPictureString+filename
            pictureSelected = secondPictureString
            print(filename)
        }
        else if thirdPicture == true {
            filename = thirdPictureString+filename
            pictureSelected = thirdPictureString
            print(filename)
        }
        else {
            //let filename = "\(timestamp).jpg"
            filename = String(timestamp)+filename

        }
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Image data could not be compressed")
            return
        }
        
        
        // pathsList section from previous weeks
        let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = pathsList[0]
        let imageFile = documentDirectory.appendingPathComponent(filename)
        
        
        // Write the data to the imageFile location
        do {
            try data.write(to: imageFile)
        } catch {
            displayMessage(title: "Error", message: "\(error)")
        }
        // Core data
        // Store the filename into a Core Data entity so that we can retrieve it at a later date
        let _ = coreDataDatabaseController?.addImage(imageURL: filename)
        
        // Calling the delegate method
        if profilePicture == true {
            profilePictureDelegate?.profilePictureChange(profilePictureFileName: filename)
            print("Calling profilePictureChange method from camera view controller")
        }
        else if firstPicture == true {
            firstPictureDelegate?.firstPictureChange(fileName: filename)
            print("Calling firstPictureChange method from camera view controller")
        }
        else if secondPicture == true {
            secondPictureDelegate?.secondPictureChange(fileName: filename)
            print("Calling secondPictureChange method from camera view controller")
        }
        else if thirdPicture == true {
            thirdPictureDelegate?.thirdPictureChange(fileName: filename)
            print("Calling thirdPictureChange method from camera view controller")
        }
        
        
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func takePhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self
        let actionSheet = UIAlertController(title: nil, message: "Select Option:", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in controller.sourceType = .camera
        self.present(controller, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in controller.sourceType = .photoLibrary
        self.present(controller, animated: true, completion: nil)
        }
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { action in controller.sourceType = .savedPhotosAlbum
        self.present(controller, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) { actionSheet.addAction(cameraAction)
        }
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // core data
        coreDataDatabaseController = appDelegate.coreDataDatabaseController
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }



}

// MARK: - Protocols

// Protocols for image delegation
// This protocol is for the profile picture change
protocol ProfilePictureDelegate: AnyObject {
    func profilePictureChange(profilePictureFileName: String)
}

protocol FirstPictureDelegate: AnyObject {
    func firstPictureChange(fileName: String)
}

protocol SecondPictureDelegate: AnyObject {
    func secondPictureChange(fileName: String)
}

protocol ThirdPictureDelegate: AnyObject {
    func thirdPictureChange(fileName: String)
}

// Delegate for sending the image data so that it can be uploaded to firestore
protocol ImageDataDelegate: AnyObject {
    func imageData(data: Data, pictureSelected: String)
}
