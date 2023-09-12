//
//  SelectDogPersonalityTableViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 12/5/2022.
//

import UIKit

// Adding a delegate protocol so that we can communicate the dog size selected to the sign up view controller
protocol DogPersonalityChangeDelegate: AnyObject {
    func dogPersonalityChange(dogPersonalityChosen: String)
}

class SelectDogPersonalityTableViewController: UITableViewController {
    
    // Add the delegate property to the class
    weak var delegate: DogPersonalityChangeDelegate?

    let NUMBER_SECTIONS = 1
    let CELL_DOG_PERSONALITY = "dogPersonalityCell"
    
    // This array contains the different dog sizes
    var dogPersonality = ["Confident", "Shy", "Independent", "Laidback/Happy", "Adaptable"]
    
    // Dictionary created for the different descriptions of the dog sizes
    var personalityDescriptions = ["Confident": "Comfortable in their surroundings and tends to be a leader and/or team player", "Shy": "Timid and reserved and tends to be anxious in strange places/circumstances.", "Independent": "Happy being alone and may appear to be distanct or unfriendly.", "Laidback/Happy": "Very friendly, enthusiastic and get along with everyone.", "Adaptable": "Calm, loving and tends to please those around them"]
   

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
        return dogPersonality.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dogPersonalityCell = tableView.dequeueReusableCell(withIdentifier: CELL_DOG_PERSONALITY, for: indexPath)
        
        // Configure the cell...
        var content = dogPersonalityCell.defaultContentConfiguration()
        let dogPersonality = dogPersonality[indexPath.row]
        let dogPersonalityDescription = personalityDescriptions[dogPersonality]
        content.text = dogPersonality
        content.secondaryText = dogPersonalityDescription
        dogPersonalityCell.contentConfiguration = content
        

        return dogPersonalityCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dogPersonalitySelected = dogPersonality[indexPath.row]
        
        // Inform the delegate of the change to the dog size
        delegate?.dogPersonalityChange(dogPersonalityChosen: dogPersonalitySelected)
        navigationController?.popViewController(animated: true)
    }
}
