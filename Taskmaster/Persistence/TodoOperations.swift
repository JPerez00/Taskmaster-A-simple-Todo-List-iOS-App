//
//  TodoOperations.swift
//  Taskmaster
//
//  Created by Jorge Perez on 2021-03-20.
//

import CoreData

struct TodoOperations {
    
    public static func create(_ description: String, using managedObjectContext: NSManagedObjectContext) {
        let newTodo = Todo(context: managedObjectContext)
        newTodo.id = UUID()
        newTodo.todoDescription = description
        newTodo.dateCreated = Date()
        newTodo.isComplete = false
        newTodo.isImportant = false
        
        saveChanges(using: managedObjectContext)
    }
    
    public static func delete(todo: Todo, using managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.delete(todo)
        saveChanges(using: managedObjectContext)
    }
    
    public static func toggleIsImportant(_ todo: Todo?, using managedObjectContext: NSManagedObjectContext) {
        todo!.isImportant = !todo!.isImportant
        saveChanges(using: managedObjectContext)
    }
    
    public static func toggleIsComplete(_ todo: Todo?, using managedObjectContext: NSManagedObjectContext) {
        todo!.isComplete = !todo!.isComplete
        saveChanges(using: managedObjectContext)
    }
    
    fileprivate static func saveChanges(using managedObjectContext: NSManagedObjectContext) {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
