
//
//  DetailView.swift
//  firstApp
//
//  Created by Alexandre  Brillon on 2024-10-03.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @State var toDo: ToDo
    @State private var item = ""
    @State private var reminderIsOn = false
    @State private var dueDate = Date.now + 60*60*24
    @State private var notes = ""
    @State private var isCompleted = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List{
            TextField("Enter To Do Here", text: $item)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
                .listRowSeparator(.hidden)
            
            Toggle("Set Reminder:", isOn: $reminderIsOn)
                .padding(.top)
                .listRowSeparator(.hidden)
            
            DatePicker("Date: ", selection: $dueDate)
                .listRowSeparator(.hidden)
                .padding(.bottom)
                .disabled(!reminderIsOn)
            
            Text("Notes:")
                .padding(.top)
            TextField("Notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .listRowSeparator(.hidden)
            
            Toggle("Completed", isOn: $isCompleted)
                .padding(.top)
                .listRowSeparator(.hidden)
                
        } .listStyle(.plain)
            .onAppear() {
                item = toDo.item
                reminderIsOn = toDo.reminderIsOn
                dueDate = toDo.dueDate
                notes = toDo.notes
                isCompleted = toDo.isCompleted
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        //ADD SAVE CODE HERE
                        toDo.item = item
                        toDo.reminderIsOn = reminderIsOn
                        toDo.dueDate = dueDate
                        toDo.notes = notes
                        toDo.isCompleted = isCompleted
                        modelContext.insert(toDo)
                        dismiss()
                    }
                }
            }
    }
}

#Preview {
    NavigationStack{
        DetailView(toDo: ToDo())
            .modelContainer(for: ToDo.self, inMemory: true)
    }
}
