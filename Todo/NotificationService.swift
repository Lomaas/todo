//
//  NotificationService.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import Foundation
import UIKit

class NotificationService {
    static func showNotifications(todos: [Todo]) {
        let notifications = Notification.getShowedNotifications()
        
        for todo in todos {
            if let noti = hasNotification(todo.id, notifications: notifications) {
                println(" timeIntervalSinceDate \(abs(noti.date.timeIntervalSinceDate(NSDate())))")
                
                if abs(noti.date.timeIntervalSinceDate(NSDate())) > Double(Settings.getTimeBetweenNotifications()) {
                    createUiLocalNotification(todo)
                    let notificationItem = Notification(id: todo.id, date: NSDate())
                    notificationItem.setShowedNotification()
                }
            } else {
                createUiLocalNotification(todo)
                let notificationItem = Notification(id: todo.id, date: NSDate())
                notificationItem.setShowedNotification()
            }
        }
    }
    
    static func hasNotification(id: String, notifications: [Notification]) -> Notification? {
        for noti in notifications {
            if (noti.id == id) {
                return noti
            }
        }
        return nil
    }
    
    static func createUiLocalNotification(todo: Todo) {
        var notification = UILocalNotification()
        notification.alertBody = "You are close by todo: \"\(todo.title)\""
        notification.alertAction = "Ok"
        notification.fireDate = NSDate()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": todo.id]
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}