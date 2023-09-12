//
//  UserCore+CoreDataProperties.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 12/5/2022.
//
//

import Foundation
import CoreData


extension UserCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCore> {
        return NSFetchRequest<UserCore>(entityName: "UserCore")
    }

    @NSManaged public var dogAgeCore: String?
    @NSManaged public var dogBreedCore: String?
    @NSManaged public var dogNameCore: String?
    @NSManaged public var dogPersonalityTypeCore: String?
    @NSManaged public var dogPlayStyleCore: String?
    @NSManaged public var dogSizeCore: String?
    @NSManaged public var interestsCore: String?
    @NSManaged public var nameCore: String?
    @NSManaged public var personAgeCore: String?
    @NSManaged public var likedEventsCore: NSSet?
    @NSManaged public var userEventsCore: NSSet?

}

// MARK: Generated accessors for likedEventsCore
extension UserCore {

    @objc(addLikedEventsCoreObject:)
    @NSManaged public func addToLikedEventsCore(_ value: EventCore)

    @objc(removeLikedEventsCoreObject:)
    @NSManaged public func removeFromLikedEventsCore(_ value: EventCore)

    @objc(addLikedEventsCore:)
    @NSManaged public func addToLikedEventsCore(_ values: NSSet)

    @objc(removeLikedEventsCore:)
    @NSManaged public func removeFromLikedEventsCore(_ values: NSSet)

}

// MARK: Generated accessors for userEventsCore
extension UserCore {

    @objc(addUserEventsCoreObject:)
    @NSManaged public func addToUserEventsCore(_ value: EventCore)

    @objc(removeUserEventsCoreObject:)
    @NSManaged public func removeFromUserEventsCore(_ value: EventCore)

    @objc(addUserEventsCore:)
    @NSManaged public func addToUserEventsCore(_ values: NSSet)

    @objc(removeUserEventsCore:)
    @NSManaged public func removeFromUserEventsCore(_ values: NSSet)

}

extension UserCore : Identifiable {

}
