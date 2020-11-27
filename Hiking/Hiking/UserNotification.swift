

import Foundation
import UserNotifications
func scheduleNotification(title:String,body:String) {
        let notificationCenter = UNUserNotificationCenter.current()
        var notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.categoryIdentifier = "alarm"
        notification.userInfo = ["additionalData": "Additional data can also be provided"]
        notification.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        
        
        // Add Action button to notification
        let actionButton = UNNotificationAction(identifier: "TapToReadAction", title: "Tap to read", options: .foreground)
        let actionShareButton = UNNotificationAction(identifier: "TapToShareAction", title: "Share", options: .foreground)
        let notificationCategory = UNNotificationCategory(identifier: "alarm", actions: [actionButton,actionShareButton], intentIdentifiers: [])
        notificationCenter.setNotificationCategories([notificationCategory])
        
        notificationCenter.add(notificationRequest)
    }
