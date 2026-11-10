//
//  TodoItem.swift
//  MyApp
//
//  Created by Compton, Travis Anderson on 11/5/26.
//

import Foundation;
import SwiftData;
import SwiftUI

@Model
final class TodoItem {
    var id: UUID;
    var title: String;
    var notes: String;
    
    //organization
    var priority: Int; //Priority 0-3
    var taskType: String;
    
    var priorityName: String {
        switch priority {
            case 1:
                return "Lo";
            case 2:
                return "Med";
            case 3:
                return "Hi";
            default:
                return "";
        }
    }
    
    //scheduling
    var dueDate: Date?
    var hasSpecificTime: Bool;
    
    var isCompleted: Bool = false;
    var completedDate: Date? = nil;
    
    var isArchived: Bool = false;
    
    var expirationDays: Int? //move to Past Tasks
    var deletionDays: Int? //fully delete the task
    
    init(
        title: String,
        notes: String = "",
        category: String = "Personal",
        priority: Int = 0,
        taskType: String = "Task",
        dueDate: Date? = nil,
        hasSpecificTime: Bool = false,
        
        
    ){
        self.id = UUID();
        self.title = title;
        self.notes = notes;
        self.priority = priority;
        self.taskType = taskType;
        self.dueDate = dueDate;
        self.hasSpecificTime = hasSpecificTime;
        
        self.isCompleted = false;
        self.completedDate = nil;
        
        self.isArchived = false;
        
        self.expirationDays = 15;
        self.deletionDays = 30;
    }
    
    func CompleteTask(){
        self.isCompleted = true;
        self.completedDate = Date()
        
        self.isArchived = true;
    }
    
    func GetPriorityColor() -> Color{
        switch self.priority {
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .red
        default:
            return .clear
        }
    }
    
}
