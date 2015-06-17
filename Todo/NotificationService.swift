//
//  NotificationService.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import Foundation
import UIKit

enum NotificationType: Int {
    case locationBased = 0
    case dateBased = 1
}

let notificationCategoryIdent  = "ACTIONABLE";
let notificationActionOneIdent = "ACTION_ONE";
let notificationActionTwoIdent = "ACTION_TWO";

class NotificationService {
    
    static func showNotifications(todos: [Todo]) {
        let notifications = Notification.getShowedNotifications()
        
        for todo in todos {
            if let noti = hasNotification(todo.id, notifications: notifications) {
                print(" timeIntervalSinceDate \(abs(noti.date.timeIntervalSinceDate(NSDate())))")
                
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
        let notification = UILocalNotification()
        notification.alertBody = "Remember to \"\(todo.title)\""
        notification.alertTitle = "Reminder"    // will be the short look title of notification on apple watch
        notification.fireDate = NSDate()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": todo.id, "type" : NotificationType.locationBased.rawValue]
        notification.category = notificationCategoryIdent
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func gotNotification(userInfo: [NSObject : AnyObject]) {
        if let id = userInfo["id"] as? String {
            Notification.deleteNotification(id)
            Todos.deleteTodoWithId(id)
        }
    }
    
    func registerForNotification() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if (notificationSettings.types != UIUserNotificationType.None){
            return
        }
        
        let action1 = UIMutableUserNotificationAction()
        action1.activationMode = UIUserNotificationActivationMode.Background
        action1.title = "Complete"
        action1.identifier = notificationActionOneIdent
        action1.destructive = false
        action1.authenticationRequired = false
        
        let action2 = UIMutableUserNotificationAction()
        action2.activationMode = UIUserNotificationActivationMode.Background
        action2.title = "Remind me later"
        action2.identifier = notificationActionTwoIdent
        action2.destructive = false
        action2.authenticationRequired = false
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = notificationCategoryIdent
        actionCategory.setActions([action2, action1], forContext: UIUserNotificationActionContext.Minimal)
        
        let categories: Set<UIUserNotificationCategory> = [actionCategory]
        
        let types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        
        let settings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
}