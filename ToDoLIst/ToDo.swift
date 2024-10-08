//
//  ToDo.swift
//  firstApp
//
//  Created by Alexandre  Brillon on 2024-10-03.
//

import Foundation
import SwiftData


@MainActor
@Model
class ToDo{
    var item: String = ""
    var reminderIsOn = false
    var dueDate = Date.now + 60*60*24
    var notes = ""
    var isCompleted = false
    
    init(item: String = "", reminderIsOn: Bool = false, dueDate: Date = Date.now + 60*60*24, notes: String = "", isCompleted: Bool = false) {
        self.item = item
        self.reminderIsOn = reminderIsOn
        self.dueDate = dueDate
        self.notes = notes
        self.isCompleted = isCompleted
    }
   
}

//Mock Data
extension ToDo {
    static var preview: ModelContainer{
        let container = try! ModelContainer(for: ToDo.self, configurations:
                                                ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(ToDo(item: "Reminder Placeholder", reminderIsOn: true, dueDate: Date.now + 60*60*24, notes: "Let's get started!", isCompleted: false))
        
        return container
    }
}
