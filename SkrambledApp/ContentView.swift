import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext;
    
    @Query(sort: \TodoItem.title)
    private var tasks: [TodoItem]; //array of TodoItems
    
    private var sortedTasks: [TodoItem] {
        tasks.filter{!$0.isCompleted && !$0.isArchived}
            .sorted { first, second in
            
            //first sort by priority
            if(first.priority != second.priority){
                return first.priority > second.priority
            }
            
            //second sort by due date, earliest to latest
            
            switch(first.dueDate, second.dueDate){
            case let (firstDate?, secondDate?): //if they both have a due date
                return firstDate < secondDate //first appears first if its date is sooner
                
            case (_?, nil): //first has a due date, second doesn't
                return true
                
            case (nil, _?): //first doesn't have a due date, second does
                return false
                
            case (nil, nil): //neither have a due date, so sort alphabetically
                return first.title < second.title
            }
        }
    }
    
    private var currentDate : Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    
                    NavigationLink("Past Tasks"){
                        PastTasksView()
                    }
                    .padding()
                    
                    Button("Test Notif"){
                        NotificationManager.shared.ScheduleTestNotifications()
                    }
                    
                    Button(){
                        CreateTask();
                    } label: {
                        Image(systemName: "plus.circle")
                            
                    }
                    .padding()
                }
                
                List {
                    ForEach(sortedTasks) { task in //for each task in tasks
                        
                        NavigationLink {
                            EditTaskView(currentTask: task) //Go to EditTaskView with task that was clicked
                        } label :{
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4){
                                    Text(task.title)
                                        .font(.headline)
                                    
                                    if(task.hasDueDate){
                                        if let dueDate = task.dueDate {
                                            Text(dueDate, format:
                                                .dateTime
                                                .month(.abbreviated)
                                                .hour()
                                                .minute()
                                                .day()
                                            )
                                            .font(.subheadline)
                                            .foregroundStyle(currentDate > dueDate ? .red : .secondary)
                                        }
                                    }
                                    
                                    if(!task.notes.isEmpty){
                                        Text(task.notes)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer();
                                
                                Text(task.priorityName)
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(task.GetPriorityColor())
                                    .clipShape(RoundedRectangle(cornerRadius:10))
                                
                                
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false){
                            Button(role: .destructive){
                                
                                NotificationManager.shared.CancelNotifications(for: task)
                                
                                modelContext.delete(task)
                            } label: {
                                Label("", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false){
                            Button(){
                                
                                NotificationManager.shared.CancelNotifications(for: task)
                                
                                task.CompleteTask()
                            }label: {
                                Label("", systemImage: "checkmark")
                            }
                            .tint(.green)
                            
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Tasks")
        .onAppear{
            ArchiveOldTasks()
            DeleteExpiredTasks()
            
            NotificationManager.shared.RequestNotificationPermission()
            
            
        }
        
    }
    
    func CreateTask() {
        print("Creating new task")

        let task = TodoItem(title: "New Task", priority: 0)
        modelContext.insert(task)
        
        print("Inserted object: \(task.title)")
        print("Has changes: \(modelContext.hasChanges)")

        do {
            try modelContext.save()
            
            print("Has changes after save: \(modelContext.hasChanges)")
            
            

            let descriptor = FetchDescriptor<TodoItem>()
            let savedTasks = try modelContext.fetch(descriptor)

            print("Task saved successfully")
            print("Fetched tasks: \(savedTasks.count)")
            print("Query tasks: \(tasks.count)")

        } catch {
            print("SwiftData error: \(error)")
        }
    }
    
    func DeleteExpiredTasks(){
        
        for task in tasks {
            //only delete completed tasks
            
            guard task.isCompleted else {continue}
            
            guard let dueDate = task.dueDate else {continue}
            
            guard let deletionDays = task.deletionDays else {continue}
            
            guard let deletionDate = Calendar.current.date(
                byAdding: .day,
                value: deletionDays,
                to: dueDate
            ) else {continue}
            
            if currentDate >= deletionDate {
                
                NotificationManager.shared.CancelNotifications(for: task)
                
                modelContext.delete(task)
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Couldn't delete expired tasks")
        }
    }
    
    func ArchiveOldTasks() {
        
        for task in tasks {
            guard let dueDate = task.dueDate else {continue}
            
            guard let expirationDays = task.expirationDays else {continue}
            
            guard let expirationDate = Calendar.current.date(
                byAdding: .day,
                value: expirationDays,
                to: dueDate
            ) else {continue}
            
            if currentDate >= expirationDate {
                
                NotificationManager.shared.CancelNotifications(for: task)
                
                task.isArchived = true
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Couldn't archive old tasks")
        }
        
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self)
}

