//
//  Info_image+CoreDataProperties.swift
//  ca_SocialMediaApp
//
//  Created by user on 2/12/2023.
//
//

import Foundation
import CoreData


extension Info_image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Info_image> {
        return NSFetchRequest<Info_image>(entityName: "Info_image")
    }

    @NSManaged public var content: String?
    @NSManaged public var image: Data?
    @NSManaged public var location: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Info_image : Identifiable {

}
