//
//  ChatMessage.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 5/25/22.
//
import UIKit
import MessageKit

class ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: Sender, messageId: String, sentDate: Date, message: String) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = .text(message)
    }
}
