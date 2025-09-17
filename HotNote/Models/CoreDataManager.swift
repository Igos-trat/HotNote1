//
//  CoreDataManager.swift
//  HotNote
//
//  Created by Игорь Ущин on 08.07.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared  =  CoreDataManager(modelNmae: "HotNote")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelNmae: String) {
        persistentContainer = NSPersistentContainer(name: modelNmae)
    }
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (_, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    func save() {
        if viewContext.hasChanges {
            do {
           try viewContext.save()
            } catch {
                print("an error \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataManager {
    
    func createNote() -> Note {
        let note = Note(context: CoreDataManager.shared.viewContext)
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        save()
        return note
    }
    
    func fetchNotes(filter: String? = nil) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor =  NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let filter = filter {
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        save()
    }
}
