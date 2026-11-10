import SwiftUI
import SwiftData

struct PastTasksView : View{
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(
        filter: #Predicate<TodoItem> { task in
            task.isCompleted == true
        },
        sort: \TodoItem.dueDate
    )
    
    private var completedTasks: [TodoItem]
    
    var body : some View{
        List{
            ForEach(completedTasks) { task in
                HStack{
                    VStack(alignment: .leading, spacing: 4){
                        Text(task.title)
                            .font(.headline)
                        
                        if let dueDate = task.dueDate{
                            Text("\(dueDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if(!task.notes.isEmpty){
                            Text(task.notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let completedDate = task.completedDate {
                            Text("Completed \(completedDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.subheadline)
                                .foregroundStyle(
                                    task.dueDate.map { completedDate > $0 ? Color.red : Color.green } ?? .green
                                )
                        }
                        
                    }
                    
                    Spacer()
                    
                    Text(task.priorityName)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(task.GetPriorityColor())
                        .clipShape(RoundedRectangle(cornerRadius:10))
                    
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
                        task.isCompleted = false
                        task.completedDate = nil
                    }label: {
                        Label("", systemImage: "arrow.trianglehead.clockwise")
                    }
                    .tint(.blue)
                    
                }
            }
        }
        .navigationTitle("Past Tasks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PastTasksView()
    .modelContainer(for: TodoItem.self)
}
