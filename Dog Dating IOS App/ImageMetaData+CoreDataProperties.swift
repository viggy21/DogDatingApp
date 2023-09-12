//
//  ImageMetaData+CoreDataProperties.swift
//  FIT3178-Assignment
//
//  Created by user216683 on 5/30/22.
//
//

import Foundation
import CoreData


extension ImageMetaData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageMetaData> {
        return NSFetchRequest<ImageMetaData>(entityName: "ImageMetaData")
    }

    @NSManaged public var filename: String?

}

extension ImageMetaData : Identifiable {

}
