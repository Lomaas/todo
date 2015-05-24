//
//  Todos.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import Foundation
import CoreLocation

class Todos: NSObject, NSCoding {
    var todos: [Todo]
    
    init(todos: [Todo]) {
        self.todos = todos
    }
    
    static func todosCloseBy(userLocation: CLLocation) -> [Todo]? {
        var todos = Todos.get()
        var todosCloseBy = todos.todos.filter {
            if let todoLocation = $0.location {
                var loc = CLLocation(latitude: todoLocation.latitude, longitude:todoLocation.latitude)
                
                if loc.distanceFromLocation(userLocation) > Settings.getDistanceToNotify() {
                    return true
                }
            }
            return false
        }
        return todosCloseBy
    }
    
    static func deleteTodoWithId(id: String) {
        var todos = Todos.get()
        todos.todos = todos.todos.filter { $0.id != id}
        todos.save()
        Notification.deleteNotification(id)
    }
    
    func save() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: "todos")
    }
    
    static func get() -> Todos {
        let defaults = NSUserDefaults.standardUserDefaults()
        var todos: Todos
        
        if let encodedObject = defaults.objectForKey("todos") as? NSData {
            todos = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as! Todos
        } else {
            todos = Todos(todos: [Todo]())
        }
        
        return todos
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.todos = aDecoder.decodeObjectForKey("todos") as! [Todo]
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.todos, forKey: "todos")
    }
}