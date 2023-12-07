//
//  Entity+CoreDataProperties.swift
//  ca_SocialMediaApp
//
//  Created by user on 2/12/2023.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var image: URL?
    @NSManaged public var location: String?

}

extension Entity : Identifiable {

}
