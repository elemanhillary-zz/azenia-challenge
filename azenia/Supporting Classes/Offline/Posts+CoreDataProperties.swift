//
//  Posts+CoreDataProperties.swift
//  
//
//  Created by MacBook Pro on 6/11/21.
//
//

import Foundation
import CoreData


extension Posts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Posts> {
        return NSFetchRequest<Posts>(entityName: "Posts")
    }

    @NSManaged public var userId: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}
