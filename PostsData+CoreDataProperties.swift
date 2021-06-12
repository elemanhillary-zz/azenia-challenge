//
//  PostsData+CoreDataProperties.swift
//  
//
//  Created by MacBook Pro on 6/11/21.
//
//

import Foundation
import CoreData


extension PostsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostsData> {
        return NSFetchRequest<PostsData>(entityName: "PostsData")
    }

    @NSManaged public var userId: String?
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: Int32

}
