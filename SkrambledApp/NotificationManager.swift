import Foundation
import UserNotifications

class NotificationManager : NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    
    func RequestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]){
                granted, error in
                
                if let error = error {
                    print("notification permission error: \(error)")
                }
            }
    }
    
    func ScheduleTestNotifications(){
        let content = UNMutableNotificationContent()
        
        content.title = "Example"
        content.body = "Some text"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "testNotification",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error{
                print("failed to schedule notification: \(error)")
            } else {
                print("test notification scheduled")
            }
        }
    }
    
    func ScheduleNotifications(for task: TodoItem){
        CancelNotifications(for: task) //get rid of any existing notifications for this task
        
        guard task.notifyMe else {return} //don't schedule notifications if notifyMe is false
        
        guard !task.isCompleted, let dueDate = task.dueDate else { return } //don't schedule notifications for tasks without a due date
        
        let reminders: [(String, TimeInterval, String)] = [
            ("48h", 172800, "Due in 48 hours."),
            ("24h", 86400, "Due in 24 hours."),
            ("1h", 3600, "Due in 1 hour."),
            ("30m", 1800, "Due in 30 minutes."),
            ("15m", 900, "Due in 15 minutes."),
            ("due", 0, "This task is due now.")
        ]
        
        for (identifier, offset, message) in reminders {
            let notificationDate = dueDate.addingTimeInterval(-offset)
            let timeUntilNotification = notificationDate.timeIntervalSinceNow
            
            guard timeUntilNotification > 1 else {continue} //don't schedule in the past
            
            let content = UNMutableNotificationContent()
            content.title = task.title
            content.body = message
            content.sound = .defaultCritical
            
            let trigger = UNTimeIntervalNotificationTrigger (
                timeInterval: timeUntilNotification,
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "\(task.id.uuidString)_\(identifier)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Notification scheduling failed: \(error)")
                }
            }
        }
    }
    
    func CancelNotifications(for task: TodoItem){
        let identifiers = [
            "\(task.id.uuidString)_48h",
            "\(task.id.uuidString)_24h",
            "\(task.id.uuidString)_1h",
            "\(task.id.uuidString)_30m",
            "\(task.id.uuidString)_15m",
            "\(task.id.uuidString)_due",
        ]
        
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            completionHandler([.banner, .sound, .badge])
        }

}
