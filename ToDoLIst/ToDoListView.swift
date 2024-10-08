
    //  ContentView.swift
    //  firstApp
    //
    //  Created by Alexandre  Brillon on 2024-10-03.
    //

    import SwiftUI
    import SwiftData

    enum SortOption: String, CaseIterable {
        case asEntered = "Unsorted"
        case alphabetical = "A-Z"
        case chronological = "By Date"
        case completed = "Not Done"
}

struct SortedToDoList: View{
    @Query var toDos: [ToDo]
    @Environment(\.modelContext) var modelContext
    let sortSelection: SortOption
    init(sortSelection: SortOption) {
        self.sortSelection = sortSelection
        switch self.sortSelection {
            case .asEntered:
            _toDos = Query()
        case .alphabetical:
            _toDos = Query(sort: \.item)
            case .chronological:
            _toDos = Query(sort: \.dueDate)
        case .completed:
            _toDos = Query(filter: #Predicate{$0.isCompleted == false})
        }
    }
    var body: some View {
        List {
            ForEach(toDos) {toDo in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: toDo.isCompleted ? "checkmark.rectangle" : "rectangle")
                            .onTapGesture {
                                toDo.isCompleted.toggle()
                                guard let _ = try? modelContext.save() else {
                                    print("😡 Error could not save after .toggle")
                                    return
                                }
                            }
                        NavigationLink{
                            DetailView(toDo: toDo)
                        } label: {
                            Text(toDo.item)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(toDo)
                                guard let _ = try? modelContext.save() else {
                                    print("😡 Error could not save after .delete")
                                    return
                                }
                            }
                        }
                    }
                    .font(.title2)
                    HStack {
                        Text(toDo.dueDate.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.secondary)
                        if toDo.reminderIsOn {
                            Image(systemName: "calendar.badge.clock")
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                }
            }
            
            
        }.listStyle(.plain)
    }
}

    struct ToDoListView: View {
        @State var sheetIsPresented = false
        @State private var sortSelection: SortOption = .asEntered
        
        
        var body: some View {
            NavigationStack {
                SortedToDoList(sortSelection: sortSelection)
                .navigationTitle("To Do List")
                    .navigationBarTitleDisplayMode(.automatic)
                    .sheet(isPresented: $sheetIsPresented) {
                        NavigationStack {
                            DetailView(toDo: ToDo())
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                sheetIsPresented.toggle()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Picker ("", selection: $sortSelection) {
                                ForEach(SortOption.allCases, id: \.self) { sortOrder in
                                    Text(sortOrder.rawValue)
                
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
            }
        }
    }

    #Preview {
        ToDoListView()
            .modelContainer(ToDo.preview)
    }

