//
//  CoreDataController.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 5/30/22.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol {
    
    
    
   
    
    
    // Instantiating the class properties
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init() {
        // Initialising the Persistent Container property
        persistentContainer = NSPersistentContainer(name: "Model")
        // Loading the Core Data stack and providing a closure for error handling.
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            } }
        super.init()
    }
    
    
    // MARK: - DatabaseProtocol Methods
    
    // This method will check to see if there are changes to be saved inside of the view context and then save, as necessary.
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    // The addListener method adds the new database listener to the list of listeners and it will provide the listener with initial immediate results depending on what type of listener it is.
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .images || listener.listenerType == .all {
            listener.onImageChange(change: .update, images: fetchAllImages())
        }
        
    }
    
    // The removeListener method just passes the specified listener to the multicast delegate class which then removes it from the set of saved listeners.
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func loggingIn(email: String, password: String) {
        
    }
    
    func signUp(email: String, password: String) {
        
    }
    
    // For image handling
    
    // This method adds an image URL/filename to core data - it takes in the filename and generates a new imageEntity object then returns it
    func addImage(imageURL: String) {
        
        let imageEntity = NSEntityDescription.insertNewObject(forEntityName: "ImageMetaData", into: persistentContainer.viewContext) as! ImageMetaData
        imageEntity.filename = imageURL
        print("image saved successfully to core data")

    }
    
    // This method deletes an image URL from core data
    func deleteImage(imageURL: ImageMetaData) {
        persistentContainer.viewContext.delete(imageURL)
    }
    
    
    // The fetchAllImages method is used to query Core Data to retrieve all image entities stored within persistent memory. It requires no input parameters and will return an array of ImageMetaData objects.
    func fetchAllImages() -> [ImageMetaData] {
        var images = [ImageMetaData]()
        let request: NSFetchRequest<ImageMetaData> = ImageMetaData.fetchRequest()
        do {
            try images = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return images
        
    }
    
    // This method fetches images with particular file names using predicates.
    func fetchParticularImage(imageFileName: String) -> ImageMetaData {
        var imageList = [ImageMetaData]()
        
        // Predicate for sorting through the ImageMetaData objects with the given filename
        let predicate = NSPredicate(format: "filename CONTAINS[c] %@", imageFileName)
        let request: NSFetchRequest<ImageMetaData> = ImageMetaData.fetchRequest()
        request.predicate = predicate
        
        do {
            try imageList = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request for particular image failed with error: \(error)")
        }
        guard imageList.count == 1 else {
            print("The fetched image list for an image with a particular name has more than one image")
            return imageList[0]
        }
        let image = imageList[0]
        return image
        
    }
    
    // This method replaces the image filename with another filename
    func replaceImage() {
        
    }
    
    // Event methods
    func addEvent(creator: String, dateAndTime: String, eventDescription: String, location: String, name: String) -> Event {
        let event = Event()
        event.creator = creator
        event.dateAndTime = dateAndTime
        event.eventDescription = eventDescription
        event.location = location
        event.name = name
       
        return event
    }
    func setupEventListener() {
        
    }
    func setupUserListener() {
        
    }
    
    
    // User methods
    func addUserToUserLiked(likedUser: User, currentUserID: String) -> Bool {
        return false
    }
    func addUserToUserDisliked(dislikedUser: User, currentUserID: String) -> Bool {
        return false
    }
}
