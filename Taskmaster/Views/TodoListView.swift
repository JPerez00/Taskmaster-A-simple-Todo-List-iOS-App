//
//  TodoListView.swift
//  Taskmaster
//
//  Created by Jorge Perez on 2021-03-20.
//  Copyright © 2021 Jorge Perez.
//

import SwiftUI
import CoreData

// Main view - Todo list view.
struct TodoListView : View {
    
    // MARK: - Core Data
    static let dateSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Todo.entity(),
                  sortDescriptors: [dateSortDescriptor],
                  predicate: NSPredicate(format: "isComplete == false")) var todos: FetchedResults<Todo>
    @FetchRequest(entity: Todo.entity(),
                  sortDescriptors: [dateSortDescriptor],
                  predicate: NSPredicate(format: "isComplete == true")) var completedTodos: FetchedResults<Todo>
    
    // MARK: - View State
    @State var selectedTodo: Todo? = nil
    @State var newTodo: String = ""
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            
            List {
                // Todo Cell view.
                Section(header: Text("Add Tasks To The List")) {
                    HStack {
                        TextField("New Task Here...", text: $newTodo)
                        
                        if self.newTodo.count > 0 {
                            Button(action: {
                                TodoOperations.create(self.newTodo, using: self.managedObjectContext)
                                self.newTodo = ""
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color.green).imageScale(.large)
                            }
                        }
                    }
                }
                
                Section(header: Text("Tasks In Progress")) {
                    ForEach(todos, id: \.id) { todo in
                        Button(action: {
                            self.selectedTodo = todo
                            self.showingSheet = true
                        }) {
                            TodoCell(todo: todo)
                        }
                    }
                    .onDelete(perform: deleteTodos(at:))
                }
                
                Section(header: Text("Tasks Completed")) {
                    ForEach(completedTodos, id: \.id) { completedTodo in
                        TodoCell(todo: completedTodo)
                    }
                    .onDelete(perform: deleteCompletedTodos(at:))
                }
            } // Main navbar, with title and button.
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("TaskMaster 🔖"))
            .navigationBarItems(trailing: EditButton())
            
            
        }
        .actionSheet(isPresented: $showingSheet, content: {
            ActionSheet(
                title: Text("Todo Actions"),
                message: nil,
                buttons: [
                    ActionSheet.Button.default(Text((self.selectedTodo?.isImportant ?? false) ? "Unflag" : "Flag")) {
                            TodoOperations.toggleIsImportant(self.selectedTodo, using: self.managedObjectContext)
                            self.showingSheet = false
                    }, ActionSheet.Button.default(Text("Mark as \((self.selectedTodo?.isComplete ?? false) ? "Incomplete" : "Complete")")) {
                            TodoOperations.toggleIsComplete(self.selectedTodo, using: self.managedObjectContext)
                            self.showingSheet = false
                    }, ActionSheet.Button.cancel({
                        self.showingSheet = false
                    })])
        })
    }
    
    func deleteTodos(at indexSet: IndexSet) {
        indexSet.forEach { TodoOperations.delete(todo: todos[$0], using: self.managedObjectContext) }
    }
    
    func deleteCompletedTodos(at indexSet: IndexSet) {
        indexSet.forEach { TodoOperations.delete(todo: completedTodos[$0], using: self.managedObjectContext) }
    }
} 

#if DEBUG
struct TodoListView_Previews : PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environment(\.managedObjectContext, PersistenceManager().managedObjectContext)
    }
}
#endif
