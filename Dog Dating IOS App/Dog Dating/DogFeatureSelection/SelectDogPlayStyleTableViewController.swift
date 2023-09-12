//
//  SelectDogPlayStyleTableViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 12/5/2022.
//

import UIKit

// Adding a delegate protocol so that we can communicate the dog size selected to the sign up view controller
protocol DogPlayChangeDelegate: AnyObject {
    func dogPlayChange(dogPlayChosen: String)
}

class SelectDogPlayStyleTableViewController: UITableViewController {

    // Add the delegate property to the class
    weak var delegate: DogPlayChangeDelegate?
    
    let NUMBER_SECTIONS = 1
    let CELL_DOG_PLAY = "dogPlayCell"
    
    // This array contains the different dog sizes
    var dogPlayStyles = ["The Wrestler", "The Lone Wolf", "The Chaser", "The Cheerleader", "The Tugger", "The Body Slammer", "The Soft Toucher"]
    
    // Dictionary created for the different descriptions of the dog sizes
    var playStyleDescriptions = ["The Wrestler": "Lots of full body contact and bared teeth. Some actions include nipping, pushing and jumping.", "The Lone Wolf" : "Likes to play alone e.g. wrestles with their toys, throws balls and runs around by themselves", "The Chaser" : "Runs around a lot and can enjoy chasing others or being chased.", "The Cheerleader" : "Plays outside of an actively playing group of dogs. They run and bark around the playing group.", "The Tugger": "Enjoys playing tug-of-war with sticks, ropes etc.", "The Body Slammer": "Like to run into other dogs and knock them over.", "The Soft Toucher": "Tends to have shorter periods of play involving soft touches and they are more hesitant and less confident when playing with other dogs"]
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return NUMBER_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dogPlayStyles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dogPlayCell = tableView.dequeueReusableCell(withIdentifier: CELL_DOG_PLAY, for: indexPath)
        
        // Configure the cell...
        var content = dogPlayCell.defaultContentConfiguration()
        let dogPlay = dogPlayStyles[indexPath.row]
        let dogPlayDescription = playStyleDescriptions[dogPlay]
        content.text = dogPlay
        content.secondaryText = dogPlayDescription
        dogPlayCell.contentConfiguration = content

        return dogPlayCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dogPlaySelected = dogPlayStyles[indexPath.row]
        // Inform the delegate of the change to the dog size
        delegate?.dogPlayChange(dogPlayChosen: dogPlaySelected)
        navigationController?.popViewController(animated: true)
    }

   

}
