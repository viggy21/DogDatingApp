//
//  EditProfileViewController.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 6/9/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dogPersonalityTypeButton: UIButton!
    @IBOutlet weak var dogPlayStyleButton: UIButton!
    @IBOutlet weak var dogSizeButton: UIButton!
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var interestsTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var thirdPictureImage: UIImageView!
    @IBOutlet weak var secondPictureImage: UIImageView!
    @IBOutlet weak var firstPictureImage: UIImageView!
    @IBOutlet weak var dogPersonalityType: UILabel!
    @IBOutlet weak var dogPlayStyle: UILabel!
    @IBOutlet weak var dogSize: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var interests: UILabel!
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    // Variables that access firestore
    var usersReference = Firestore.firestore().collection("Users")
    
    // This property is a reference to Firebase Storage which is where our images are saved to.
    var storageReference = Storage.storage().reference()
    
    var nameString: String?
    var interestsString: String?
    var dogNameString: String?
    var dogSizeString: String?
    var dogPlayStyleString: String?
    var dogPersonalityTypeString: String?
    var profilePicture: UIImage?
    var firstPicture: UIImage?
    var secondPicture: UIImage?
    var thirdPicture: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameTextField.text = nameString
        interestsTextField.text = interestsString
        dogNameTextField.text = dogNameString
        dogSizeButton.setTitle(dogSizeString, for: .normal)
        dogPlayStyleButton.setTitle(dogPlayStyleString, for: .normal)
        dogPersonalityTypeButton.setTitle(dogPersonalityTypeString, for: .normal)
        profilePictureImage.image = profilePicture
        firstPictureImage.image = firstPicture
        secondPictureImage.image = secondPicture
        thirdPictureImage.image = thirdPicture
        
            
    }
    
    
    
    /**
     This method saves the user's edits to their profile
     */
    @IBAction func save(_ sender: Any) {
    }
    
    

}
