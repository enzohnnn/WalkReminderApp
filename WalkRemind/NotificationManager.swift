//
//  NotificationManager.swift
//  WalkRemind
//
//  Created by Enzo Han on 11/29/22.
//

import Foundation
import UserNotifications


// This is a local notification manager
class NotificationManager {
    
    let messages: [String] = ["Hey! Did you reach your step goal for today? Open WalkRemind to find out.",
                              "Hope your having a wonderful day! Check your WalkRemind app to see if you hit your daily goal",
                            "How's it going? Forget to exercise today? See if you hit your goal today!",
                            "One step at a time! Open WalkRemind!",
                            "A workout today keeps the doctor away. Check your steps for today!",
                            "Sending lots of love and encouragement. Take a stroll if you haven't today.",
                            "Isn't the weather beautiful today? Go on a walk if you haven't."]
    static let instance = NotificationManager() // singleton
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS! Authorizing Notifications")
            }
        }
    }
    
    func scheduleNotification(scheduleTime: Date) {
        
        //userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["testNotification"])
        // Clear old notifications before scheduling new one
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Removing Notification")
        
        let content = UNMutableNotificationContent()
        content.title = "Check your steps!"
        content.subtitle = messages.randomElement() ?? "Check your WalkRemind to see if you hit your goal for today!"
        content.sound = .default
        content.badge = 1
        
        // time
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        // calendar
        //let dateComponents = DateComponents(from: )
        //let components = Calendar.current.dateComponents(<#Set<Calendar.Component>#>, from: scheduleTime)
        //var dateComponents
        let comps = Calendar.current.dateComponents([.hour, .minute, .timeZone, .second], from: scheduleTime)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        
        // location
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("Scheduled Notification")
    }
}
