//
//  File.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import Foundation

class Location: NSObject, NSCoding {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.latitude = aDecoder.decodeObjectForKey("latitude") as! Double
        self.longitude = aDecoder.decodeObjectForKey("longitude") as! Double
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.latitude, forKey: "latitude")
        _aCoder.encodeObject(self.longitude, forKey: "longitude")
    }
}