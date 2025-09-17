//
//  Note+CoreDataProperties.swift
//  HotNote
//
//  Created by Игорь Ущин on 06.07.2022.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var text: String!
    @NSManaged public var lastUpdated: Date!
    @NSManaged public var id: UUID!

}

extension Note: Identifiable {

}
