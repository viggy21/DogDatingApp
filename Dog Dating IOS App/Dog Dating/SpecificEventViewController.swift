//
//  SpecificEventViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 19/5/2022.
//

import UIKit

class SpecificEventViewController: UIViewController {
    
    // The specific event variable
    var event: Event?

    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Checking that we have an event instance
        guard let event = event else {
            print("No event set.")
            return
        }
        titleLabel.text = event.name
        timeLabel.text = event.dateAndTime
        locationLabel.text = event.location
        descriptionLabel.text = event.eventDescription
        creatorLabel.text = event.creator
        
    }
    

  
}
