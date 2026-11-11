import SwiftUI
import SwiftData

struct EditTaskView : View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var currentTask: TodoItem
    
    
    var body: some View {
        
        Form {
            Section("Task Name"){
                TextField("Task Name", text: $currentTask.title)
            }
            
            Section("Notes"){
                TextEditor(text: $currentTask.notes)
                    .frame(height: 100)
            }
            
            Section("Priority") {
                Picker("", selection: $currentTask.priority) {
                    Text("None").tag(0)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius:10))
                    Text("Low").tag(1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius:10))
                    Text("Medium").tag(2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.yellow)
                        .clipShape(RoundedRectangle(cornerRadius:10))
                    Text("High").tag(3)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius:10))
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            
            Section("Date & Time"){
                Toggle(isOn: $currentTask.hasSpecificTime){
                    Text("Has due date")
                }
                .tint(.accentColor)
                
                if(currentTask.hasSpecificTime){
                    DatePicker("Due Date", selection: Binding(
                        get: {
                            currentTask.dueDate ?? Date()
                        },
                        set: {
                            currentTask.dueDate = $0
                        }
                    )
                    )
                }
                
            }
            
            Section("Notifications"){
                Toggle(isOn: $currentTask.notifyMe){
                    Text("Notify me")
                    
                    Text("You'll be notified daily, 1 hr, 15 min before the task is due")
                }
                .tint(.accentColor)
                
            }
            
            Section("Task Expiry"){
                
                Picker("Move to Past Tasks after", selection:$currentTask.expirationDays){
                    ForEach(1...30, id: \.self){ days in
                        Text("\(days) days").tag(Optional(days))
                    }
                    
                    Text("Never Move").tag(Optional<Int>.none)
                }
                
                Picker("Delete after", selection:$currentTask.deletionDays){
                    ForEach(1...30, id: \.self){ days in
                        Text("\(days) days").tag(Optional(days))
                    }
                    
                    Text("Never Delete").tag(Optional<Int>.none)
                }
            }
            
            Section("Task Management") {
                Button("Mark as Complete") {
                    currentTask.CompleteTask()
                    dismiss()
                }
                .tint(.green)
                
                Button("Delete Task", role: .destructive){
                    modelContext.delete(currentTask)
                    dismiss()
                }
                .tint(.red)
            }
            
        }
        .navigationTitle("Edit \(currentTask.title)")
    }
}

#Preview {
    NavigationStack {
        EditTaskView(
            currentTask: TodoItem(title: "Example", priority: 2)
        )
    }
    .modelContainer(for: TodoItem.self)
}
