//
//  TodoCell.swift
//  Taskmaster
//
//  Created by Jorge Perez on 2021-03-20.
//

import SwiftUI

struct TodoCell: View {
    @ObservedObject var todo: Todo
    var body: some View {
        HStack {
            Text(todo.todoDescription ?? "")
                //.foregroundColor(.black)
                .foregroundColor(Color("textcolour"))
                .strikethrough(todo.isComplete, color: Color("strikecolour"))
            Spacer()
            if !todo.isComplete && todo.isImportant{
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.red).imageScale(.large)
            }
        }
    }
}
