//
//  Event.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit
import FirebaseFirestoreSwift

class Event: NSObject, Codable {
    @DocumentID var id: String?
    var creator: String?
    var dateAndTime: String?
    var eventDescription: String?
    var location: String?
    var name: String?

}
