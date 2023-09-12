//
//  EventCore+CoreDataProperties.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 12/5/2022.
//
//

import Foundation
import CoreData


extension EventCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventCore> {
        return NSFetchRequest<EventCore>(entityName: "EventCore")
    }

    @NSManaged public var dateAndTimeCore: String?
    @NSManaged public var eventDescriptionCore: String?
    @NSManaged public var locationCore: String?
    @NSManaged public var eventNameCore: String?
    @NSManaged public var creatorCore: UserCore?
    @NSManaged public var userLikesCore: NSSet?

}

// MARK: Generated accessors for userLikesCore
extension EventCore {

    @objc(addUserLikesCoreObject:)
    @NSManaged public func addToUserLikesCore(_ value: UserCore)

    @objc(removeUserLikesCoreObject:)
    @NSManaged public func removeFromUserLikesCore(_ value: UserCore)

    @objc(addUserLikesCore:)
    @NSManaged public func addToUserLikesCore(_ values: NSSet)

    @objc(removeUserLikesCore:)
    @NSManaged public func removeFromUserLikesCore(_ values: NSSet)

}

extension EventCore : Identifiable {

}
