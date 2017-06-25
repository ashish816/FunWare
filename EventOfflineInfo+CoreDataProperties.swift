//
//  EventOfflineInfo+CoreDataProperties.swift
//  PhunwareAssignment
//
//  Created by Ashish Mishra on 6/24/17.
//  Copyright © 2017 Ashish Mishra. All rights reserved.
//

import Foundation
import CoreData


extension EventOfflineInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventOfflineInfo> {
        return NSFetchRequest<EventOfflineInfo>(entityName: "EventOfflineInfo")
    }

    @NSManaged public var eventId: Int64
    @NSManaged public var title: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventDate: String?
    @NSManaged public var imageLink: String?
    @NSManaged public var city: String?
    @NSManaged public var place: String?
    @NSManaged public var bgImage: NSData?

}
