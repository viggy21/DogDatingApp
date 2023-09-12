//
//  User.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

/*
enum CodingKeys: String, CodingKey {
    case id
    case dogAge
    case dogBreed
    case dogPersonalityType
    case dogPlayStyle
    case dogSize
    case interests
    case password
    case personAge
    case username
    case name
    case likedEvents
    case userEvents
}
*/

class User: NSObject, Codable {
    @DocumentID var id: String?
    var dogName: String?
    var dogBirthday: String?
    var dogBreed: String?
    var dogPersonalityType: String?
    var dogPlayStyle: String?
    var dogSize: String?
    var interests: String?
    var birthday: String?
    var name: String?
    var likedEvents: [String] = [] // the arrays of events are arrays of references to event documents
    var myEvents: [String] = []
    var likedUsers: [String] = []
    var dislikedUsers: [String] = []
    var matches: [String] = []
}

