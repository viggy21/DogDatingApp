//
//  FirebaseController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class FirebaseController: NSObject, DatabaseProtocol {
    
    
    
    
    

    
    
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var userList: [User]
    var defaultUser: User
    var defaultEvent: Event
    var eventList: [Event]
    
    var authController: Auth
    var database: Firestore
    var userRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    var eventsRef: CollectionReference?
    
    // Message code
    var currentSender: Sender?
    
    
    override init(){
        // If statement added to check that the app isn't being configured multiple times
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        authController = Auth.auth()
        database = Firestore.firestore()
        userList = [User]()
        eventList = [Event]()
        defaultUser = User()
        defaultEvent = Event()
        super.init()

        currentUser = authController.currentUser
        // If there is a current user signed in, we will set up the user listener and set up the event listener.
        if (currentUser != nil) {
            self.setupUserListener()
            self.setupEventListener()
        }
        
        
    }
    func loggingIn(email: String, password: String) {
        Task {
            do {
                let authDataResult = try await authController.signIn(withEmail: email, password: password)
                currentUser = authDataResult.user // this will incude the userID
                
                // Message code
                // self.currentSender = Sender(id: authDataResult.user.uid, name: currentUser.na)
                
             
            }
            catch {
                // displayMessage(title: "Error", message: "Email and password do not match")
                print("Email and password do not match")
               
            }
            
            if (currentUser != nil) {
                self.setupUserListener()
                // Load all the events
                self.setupEventListener()
                
                // If the user has logged in, we can change the root view controller to the tab bar controller
                // Additional lines from: https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/
                let storyboard = await UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = await storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from our view controller then call the change root view controller function
                // to change to main tab bar
                await (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
             
        }
        
        
    }
    
    func signUp(email: String, password: String) {
        Task {
            do {
                let authDataResult = try await authController.createUser(withEmail: email, password: password)
                currentUser = authDataResult.user // this will incude the userID
                
            }
            catch {
                print("User creation failed")
            }
            
            if (currentUser != nil) {
                self.setupUserListener()
                // Load all the events
                self.setupEventListener()
                
                // If the user has signed in, we can change the root view controller to the tab bar controller
                // Additional lines from: https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/
                let storyboard = await UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = await storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from our view controller then call the change root view controller function
                // to change to main tab bar
                await (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
             
        }
    }
    
 
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, userList: userList)
        }
        else if listener.listenerType == .events || listener.listenerType == .all {
            listener.onEventChange(change: .update, events: eventList)
        }
            
    }
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func addEvent(creator: String, dateAndTime: String, eventDescription: String, location: String, name: String) -> Event {
        let event = Event()
        event.creator = creator
        event.dateAndTime = dateAndTime
        event.eventDescription = eventDescription
        event.location = location
        event.name = name
        do {
            if let eventsRef = try eventsRef?.addDocument(from: event) {
                event.id = eventsRef.documentID
            }
        } catch {
            print("Failed to serialize event")
        }
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If no userID is found, we display an error and do not save anything because we cannot create a valid path within Firebase without and ID
            print("No current user (add event method)")
            return event
        }
        // Add the event to the user's my events list
        userRef?.document(currentUserID).updateData(["myEvents" : FieldValue.arrayUnion([event.id])])
        print("Updated the user's my events on firebase")
        return event
    }
    
   

    /**
     This method adds events that the user has liked to the collection with the list of their liked events
     */
    func addEventToUserLiked(event: Event, user: User) -> Bool {
        guard let eventID = event.id, let userID = user.id else {
            return false
        }
        
        userRef?.document(userID).updateData(["likedEvents" : FieldValue.arrayUnion([eventID])])
    
        return true
    }
    
    /**
     This method adds users that the user has liked to their liked users list and then checks if the other user has liked the current user. If they have, then the other user is added to the current user's matches list and the current user is also added to the other user's matches list.
     */
    
    
    func addUserToUserLiked(likedUser: User, currentUserID: String) -> Bool {
        guard let likedUserID = likedUser.id else {
            return false
        }
        
        userRef?.document(currentUserID).updateData(["likedUsers" : FieldValue.arrayUnion([likedUserID])])
        // Check if the current user is in the liked user's list of liked users, if they are, then add the liked user to the current user's matches list and vice versa
        
        
        if let likedUserRef = userRef?.document(likedUserID) {
            // Check if the current user is in the liked user's list of liked users, if they are, then add the liked user to the current user's matches list and vice versa
            
            // Reference: https://firebase.google.com/docs/firestore/query-data/get-data#swift_1
            // Some of the code from this reference was used to get the document data from firestore as shown below.
            likedUserRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()

                    if let data = data?["likedUsers"] {
                        // Check if the current user is in the likedUsers list of the other user
                        if let likedUsersData = data as? [String] {
                            if likedUsersData.contains(currentUserID) {
                                self.userRef?.document(currentUserID).updateData(["matches" : FieldValue.arrayUnion([likedUserID])])
                                self.userRef?.document(likedUserID).updateData(["matches" : FieldValue.arrayUnion([currentUserID])])
                            }
                           
                        }
                       
                    }
                }
            }
            
        }
        
        
        
        return true
    }
    
    /**
     This method adds users that the user has not liked to their disliked users list
     */
    func addUserToUserDisliked(dislikedUser: User, currentUserID: String) -> Bool {
        guard let dislikedUserID = dislikedUser.id else {
            return false
        }
        userRef?.document(currentUserID).updateData(["dislikedUsers" : FieldValue.arrayUnion([dislikedUserID])])
        
        return true
    }
    
    
    
    
    func deleteEvents(event: Event){
        if let eventID = event.id {
            eventsRef?.document(eventID).delete()
        }
    }
    /*
    func removeLikedEventFromUser(event: Event, user: User) {
        if user.likedEvents
    }
     */
    
    /*
    func removeHeroFromTeam(hero: Superhero, team: Team) {
        if team.heroes.contains(hero), let teamID = team.id, let heroID = hero.id {
            if let removedHeroRef = heroesRef?.document(heroID) {
                teamsRef?.document(teamID).updateData(["heroes": FieldValue.arrayRemove([removedHeroRef])] )
            }
        }
    }
     */
    func cleanup() {
        
    }
    // MARK: - Firebase Controller Specific m=Methods
    
    func getUserByID(_ id: String) -> User? {
        for user in userList { if user.id == id {
            return user
        }
        }
        return nil
    }
    
    

    func setupUserListener() {
        userRef = database.collection("Users")
        
        userRef?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch user document with error: \(String(describing: error))")
                return
            }
            self.parseUserSnapshot(snapshot: querySnapshot)
            
        }
         
    }
    
    func setupEventListener() {
        eventsRef = database.collection("Events")
        eventsRef?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseEventSnapshot(snapshot: querySnapshot)
        }
    }
    
    
    
    func parseUserSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parsedUser: User?
            do {
                parsedUser = try change.document.data(as: User.self)
            } catch {
                print("Unable to decode user. Is the user malformed?")
                return
            }
            guard let user = parsedUser else {
                print("Document doesn't exist")
                return
            }
            if change.type == .added { // this is for when users are added when new users sign up
                userList.insert(user, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                print(change.oldIndex)
                userList[Int(change.oldIndex)] = user
                
            }
            else if change.type == .removed {
                userList.remove(at: Int(change.oldIndex))
                
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all { listener.onUserChange(change: .update, userList: userList)}
            }
            print("Checking that the user has been parsed correctly")
            print(userList)
        }
    }
    
    
    // This method parses the snapshot and makes any required changes to the local properties and calls local listeners.
    func parseEventSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parsedEvent: Event?
            do {
                parsedEvent = try change.document.data(as: Event.self)
            } catch {
                print("Unable to decode event. Is the event malformed?")
                return
            }
            guard let event = parsedEvent else {
                print("Document doesn't exist")
                return
            }
            if change.type == .added {
                eventList.insert(event, at: Int(change.newIndex))
            }
            else if change.type == .modified { eventList[Int(change.oldIndex)] = event
                
            }
            else if change.type == .removed { eventList.remove(at: Int(change.oldIndex))
                
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.events || listener.listenerType == ListenerType.all { listener.onEventChange(change: .update, events: eventList)}
            }
        }
    }
     
    
    
    
    // For image handling
    func addImage(imageURL: String) {
        
    }
    
    func deleteImage(imageURL: ImageMetaData) {
        
    }
    //
    
   
}
