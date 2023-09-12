//
//  EventsListCell.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 27/4/2022.
//

import UIKit

class EventsListCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var creator: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
