//
//  NotificationManager.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 21/08/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted ,error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print(granted ? "✅ Permission granted" : "❌ Permission denied")
            }
        }
    }
    
    // MARK: - Schedule once (after X seconds)
    func scheduleNotification(id: String = UUID().uuidString,title: String, body: String, after seconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyNotification(id: String,
                                       title: String,
                                       body: String,
                                       hour: Int,
                                       minute: Int) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
        // MARK: - Cancel
        func cancelNotification(id: String) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
        
        func cancelAll() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        // MARK: - List all
        func listPending(completion: @escaping ([UNNotificationRequest]) -> Void) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                completion(requests)
            }
        }
}


//foreground notification

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Show notifications even in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
