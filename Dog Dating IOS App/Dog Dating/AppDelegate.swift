//
//  AppDelegate.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit
import Firebase

// Core data
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var databaseController: DatabaseProtocol? // This can be changed to firebaseDatabaseController
    
    // Core data
    var coreDataDatabaseController: DatabaseProtocol?
    var persistentContainer: NSPersistentContainer?
    //

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        databaseController = FirebaseController()
        
        // Core data
        coreDataDatabaseController = CoreDataController()
        //
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

