//
//  ContentView.swift
//  ToDo
//
//  Created by Slavik on 21.12.2022.
//

import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    let task: String
    var isCompleted: Bool
}

class TodoList: ObservableObject {
    @Published var items: [TodoItem]
    init(items: [TodoItem]) {
        self.items = items
    }
}

struct ContentView: View {
    @ObservedObject var todoList = TodoList(items: [
        TodoItem(task: "Take out the trash", isCompleted: false),
        TodoItem(task: "Do the dishes", isCompleted: false),
        TodoItem(task: "Wash the car", isCompleted: false)
    ])

    var body: some View {
        NavigationView {
            List {
                ForEach(todoList.items) { item in
                    HStack {
                        Text(item.task)
                        Spacer()
                        Toggle(isOn: Binding(
                            get: { item.isCompleted },
                            set: {_ in 
                                withAnimation {  // specify the animation to use
                                    var mutableItem = item
                                    mutableItem.isCompleted = !mutableItem.isCompleted
                                    if let index = self.todoList.items.firstIndex(where: { $0.id == item.id }) {
                                        self.todoList.items[index] = mutableItem
                                    }
                                }
                            }
                        )) {
                            Text("Completed")
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }

    func delete(at offsets: IndexSet) {
        todoList.items.remove(atOffsets: offsets)
    }
}
