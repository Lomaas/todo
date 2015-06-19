//
//  TodoModel.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import Foundation


class Todo: NSObject, NSCoding {
    var id: String
    var title: String
    var details: String
    var date: NSDate?
    var location: Location?
    
    init(id: String, title: String, details: String, location: Location?, date: NSDate?) {
        self.id = id
        self.title = title
        self.details = details
        self.location = location
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.details = aDecoder.decodeObjectForKey("details") as! String
        self.location = aDecoder.decodeObjectForKey("location") as? Location
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.details, forKey: "details")
        coder.encodeObject(self.location, forKey: "location")
        coder.encodeObject(self.date, forKey: "date")

    }
}