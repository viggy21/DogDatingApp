//
//  Sender.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 5/25/22.
//

import UIKit
import MessageKit

class Sender: SenderType {
    var senderId: String
    var displayName: String
    
    init(id: String, name: String) {
        self.senderId = id
        self.displayName = name
    }
}
