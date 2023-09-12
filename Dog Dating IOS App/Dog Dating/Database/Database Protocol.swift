//
//  Database Protocol.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import Foundation

enum DatabaseChange{
    case add
    case remove
    case update

}


enum ListenerType {
    case auth
    case user
    case events 
    case images
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onAuthChange(change: DatabaseChange)
    func onUserChange(change: DatabaseChange, userList: [User])
    func onEventChange(change: DatabaseChange, events: [Event])
    func onImageChange(change: DatabaseChange, images: [ImageMetaData])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func loggingIn(email: String, password: String)
    func signUp(email: String, password: String)
    
    // Image saving methods
    func addImage(imageURL: String)
    func deleteImage(imageURL: ImageMetaData)
    
    // Event methods
    func addEvent(creator: String, dateAndTime: String, eventDescription: String, location: String, name: String) -> Event
    func setupEventListener()
    func setupUserListener()
    
    // User methods (matches)
    func addUserToUserLiked(likedUser: User, currentUserID: String) -> Bool
    func addUserToUserDisliked(dislikedUser: User, currentUserID: String) -> Bool
    

}
