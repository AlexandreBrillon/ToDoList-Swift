//
//  firstAppApp.swift
//  firstApp
//
//  Created by Alexandre  Brillon on 2024-10-03.
//

import SwiftUI
import SwiftData

@main
struct ToDoList: App {
    var body: some Scene {
        WindowGroup {
            ToDoListView()
                .modelContainer(for: ToDo.self)
        }
    }
}
