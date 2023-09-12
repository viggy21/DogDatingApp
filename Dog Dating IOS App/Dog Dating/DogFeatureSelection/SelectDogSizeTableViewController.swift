//
//  SelectDogSizeTableViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 11/5/2022.
//

import UIKit

// Adding a delegate protocol so that we can communicate the dog size selected to the sign up view controller
protocol DogSizeChangeDelegate: AnyObject {
    func dogSizeChange(dogSizeChosen: String)
}


class SelectDogSizeTableViewController: UITableViewController {
    
    // Add the delegate property to the class
    weak var delegate: DogSizeChangeDelegate?
    
    let NUMBER_SECTIONS = 1
    let CELL_DOG_SIZE = "dogSizeCell"
    
    // This array contains the different dog sizes
    var dogSize = ["Small", "Medium", "Large", "Giant"]
    
    // Dictionary created for the different descriptions of the dog sizes
    var sizeDescriptions = ["Small": "Weighs between 1kg and 10kg e.g. Chihuahuas, Toy Poodles etc.", "Medium" : "Weighs between 11kg and 26kg e.g. Bull Terriers, Border Collies etc.", "Large" : "Weighs between 26kg and 44kg e.g. Labradors, Golden Retrievers etc.", "Giant" : "Weighs 45kg or more e.g. Great Danes, Bullmastiffs etc."]
    

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
        return dogSize.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dogSizeCell = tableView.dequeueReusableCell(withIdentifier: CELL_DOG_SIZE, for: indexPath)
        
        // Configure the cell...
        var content = dogSizeCell.defaultContentConfiguration()
        let dogSize = dogSize[indexPath.row]
        let dogSizeDescription = sizeDescriptions[dogSize]
        content.text = dogSize
        content.secondaryText = dogSizeDescription
        dogSizeCell.contentConfiguration = content
        return dogSizeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dogSizeSelected = dogSize[indexPath.row]
        
        // Inform the delegate of the change to the dog size
        delegate?.dogSizeChange(dogSizeChosen: dogSizeSelected)
        navigationController?.popViewController(animated: true)
        
    }

    

   
}
