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
        let todos = Todos.get()
        
        let todosCloseBy = todos.todos.filter {
            guard let todoLocation = $0.location else {
                return false
            }
            let location = CLLocation(latitude: todoLocation.latitude, longitude:todoLocation.latitude)
            
            if location.distanceFromLocation(userLocation) > Settings.getDistanceToNotify() {
                return true
            }
            return false
        }
        return todosCloseBy
    }
    
    static func deleteTodoWithId(id: String) {
        let todos = Todos.get()
        todos.todos = todos.todos.filter { $0.id != id}
        Todos.save(todos)
    }
    
    static func save(todos: Todos) {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(todos)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: "todos")
        defaults.synchronize()
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
    
    required init?(coder aDecoder: NSCoder) {
        self.todos = aDecoder.decodeObjectForKey("todos") as! [Todo]
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.todos, forKey: "todos")
    }
}