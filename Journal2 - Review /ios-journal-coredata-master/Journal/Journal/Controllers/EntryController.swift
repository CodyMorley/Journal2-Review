//
//  EntryController.swift
//  Journal
//
//  Created by Cody Morley on 8/11/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import CoreData

class EntryController {
    //MARK: Properties
    /*var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = CoreDataStack.shared.mainContext
        
        do {
            let entries = try context.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching Entries from core data: \(error)")
            return [Entry]()
        }
    }*/
    lazy var frc: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moodSortDescriptor = NSSortDescriptor(key: "mood", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [moodSortDescriptor, dateSortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "mood",
                                             cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            fatalError("Unable to fetch menu Items from frc.")
        }
        return frc
    }()
    
    
    
    //MARK: CRUD Methods
    func createEntry(title: String, body: String, mood: Mood) {
        Entry(title: title,
              bodyText: body,
              mood: mood,
              context: CoreDataStack.shared.mainContext)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Ruh roh. couldn't save your entry: \(error)")
            return
        }
    }
    
    func updateEntry(_ entry: Entry, title: String, body: String, mood: Mood) {
        entry.title = title
        entry.bodyText = body
        entry.mood = mood.rawValue
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Couldn't save the context: \(error)")
            return
        }
    }
    
    func deleteEntry(_ entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        do {
            context.delete(entry)
            try context.save()
        } catch {
            NSLog("Unable to save managed object context after deleting. \(error)")
            return
        }
    }
}
