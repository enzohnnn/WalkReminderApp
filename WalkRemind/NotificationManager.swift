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
    
    static let instance = NotificationManager() // singleton
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(scheduleTime: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "Check your steps!"
        content.subtitle = "Hey! Did you reach your step goal for today? Open WalkRemind to find out!"
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
    }
}
