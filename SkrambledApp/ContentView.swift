import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext;
    
    @Query(sort: \TodoItem.title)
    private var tasks: [TodoItem]; //array of TodoItems
    
    private var sortedTasks: [TodoItem] {
        tasks.filter{!$0.isCompleted}
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
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    
                    NavigationLink("Past Tasks"){
                        PastTasksView()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(){
                        createTask();
                    } label: {
                        Label("", systemImage: "plus.circle")
                            
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
                                    
                                    if(task.hasSpecificTime){
                                        if let dueDate = task.dueDate {
                                            Text(dueDate, format:
                                                .dateTime
                                                .month(.abbreviated)
                                                .hour()
                                                .minute()
                                                .day()
                                            )
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
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
                                modelContext.delete(task)
                            } label: {
                                Label("", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false){
                            Button(){
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
        
    }
    
    func createTask(){
        let task = TodoItem(
            title: "New Task",
            priority: 0
        )
        
        modelContext.insert(task);
        
        do {
            try modelContext.save();
        } catch {
            print("Failed to save new task: \(error)");
        }
    }
    
    func getPriorityColor(priority: Int) -> Color{
        switch priority {
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .red
        default:
            return .white
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self)
}

