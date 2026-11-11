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
    
    func ScheduleNotifications(){
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
    
    func CancelNotifications(){
        
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            completionHandler([.banner, .sound, .badge])
        }

}
