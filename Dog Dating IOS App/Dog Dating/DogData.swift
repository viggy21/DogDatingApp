//
//  DogData.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 18/5/2022.
//

import UIKit

class DogData: NSObject, Decodable {
    var dogBreed: String?
    private enum DogKeys: String, CodingKey {
        case dogBreed = "breedName" 
    }
    
    required init(from decoder: Decoder) throws {
        let dogContainer = try decoder.container(keyedBy: DogKeys.self)
        dogBreed = try dogContainer.decode(String.self, forKey: .dogBreed)
    }
    

}

