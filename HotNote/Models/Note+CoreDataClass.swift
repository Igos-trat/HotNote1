//
//  Note+CoreDataClass.swift
//  HotNote
//
//  Created by Игорь Ущин on 06.07.2022.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    
    var title: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? "" // возвращ. первую строку
    }
    
    var desc: String {
        var lines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        lines.removeFirst()
        return "\(lastUpdated.format()) \(lines.first ?? "")" // возвр. 2 строку
    }
}
