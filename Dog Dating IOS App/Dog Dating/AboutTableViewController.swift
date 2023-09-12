//
//  AboutTableViewController.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 6/10/22.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    let REFERENCE_CELL = "referenceCell"
    let NUMBER_SECTIONS = 1
    let referenceListName = ["Data for different dog sizes", "Data for different dog play styles", "Data for different dog personality types", "Shy dog data", "Using arrays in core data", "Get the name/label from the button", "API used for dog breed", "Creating a scroll view", "Changing the button text", "Convert a date to a string", "Get current date time", "Comparing date and time", "Dismiss modal view", "Encoding and decoding (for web api)", "How to transition from a login screen to a tab bar screen", "Getting the current user (managing users in firebase)", "References to document snapshots", "Understanding chat messages", "Reading button text", "Checking that there is an image in the image view", "Finding out about uid from auth only being able to be accessed when the task is complete", "Performing simple queries with firebase", "Loading another user’s image from firebase", "Firebase getting other users’ details", "Getting image data from firebase", "Image cache", "Allowing a user to edit their profile by clicking labels", "Swift break statement"]
    let referenceListWebsite = ["https://www.petbarn.com.au/petspot/dog/food-and-nutrition/tell-breed-size-dog/", "https://www.petbasics.com/lifestyle/what-is-your-dogs-play-style/#:~:text=Run%2C%20run%2C%20run%20%2D%20and,the%20thrill%20of%20the%20chase", "https://iheartdogs.com/dogs-have-these-5-major-personality-types/", "https://www.thehonestkitchen.com/blogs/pet-tips-training/6-suggestions-for-boosting-a-shy-dogs-confidence/", "https://www.hackingwithswift.com/forums/swiftui/array-of-strings-in-core-data/9572", "https://stackoverflow.com/questions/26074239/how-to-get-label-name-from-button", "https://github.com/alex-martinez-jativa/api-dog-breeds", "https://fluffy.es/scrollview-storyboard-xcode-11/", "https://stackoverflow.com/questions/26641571/how-to-change-button-text-in-swift-xcode-6", "https://cocoacasts.com/swift-fundamentals-how-to-convert-a-date-to-a-string-in-swift", "https://www.zerotoappstore.com/how-to-get-current-date-in-swift.html", "https://iostutorialjunction.com/2017/10/compare-two-dates-using-swift-in-ios.html", "https://stackoverflow.com/questions/24668818/how-to-dismiss-viewcontroller-in-swift", "https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift#toc-anchor-009", "https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/", "https://firebase.google.com/docs/auth/web/manage-users", "https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/DocumentSnapshot", "https://www.youtube.com/watch?v=6v4fmg9iRSU&ab_channel=iOSAcademy", "https://stackoverflow.com/questions/26074239/how-to-get-label-name-from-button", "https://stackoverflow.com/questions/33206477/check-if-imageview-is-empty", "https://stackoverflow.com/questions/38352772/is-there-any-way-to-get-firebase-auth-user-uid", "https://firebase.google.com/docs/firestore/query-data/queries", "https://stackoverflow.com/questions/38103407/am-i-able-to-load-another-users-profile-image-in-firebase-android#:~:text=No%2C%20you%20are%20only%20able,using%20the%20Firebase%20Auth%20library", "https://stackoverflow.com/questions/38850700/firebase-how-to-get-user-details", "https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift", "https://programmingwithswift.com/cache-image-with-swift/", "https://stackoverflow.com/questions/31446237/how-can-i-edit-a-uilabel-upon-touching-it-in-swift", "https://www.programiz.com/swift-programming/break-statement#:~:text=The%20break%20statement%20is%20used,immediately%20when%20it%20is%20encountered"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return NUMBER_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return referenceListName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REFERENCE_CELL, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = referenceListName[indexPath.row]
        content.secondaryText = referenceListWebsite[indexPath.row]
        cell.contentConfiguration = content
        print(content)

        // Configure the cell...

        return cell
    }
    

}
