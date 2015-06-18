//
//  AppleWatchCommunicator.swift
//  Todo
//
//  Created by Simen Johannessen on 18/06/15.
//  Copyright © 2015 lomas. All rights reserved.
//

import Foundation
import WatchConnectivity

class AppleWatchCommunicator: NSObject, WCSessionDelegate {
    let session: WCSession
    
    override init () {
        session = WCSession.defaultSession()
        super.init()
        
        session.delegate = self
        session.activateSession()
    }
    func sendRecentUpdate() {
        let todos = Todos.get()
        let seriliazed = todos.todos.map {
            return ["title" : $0.title, "id" : $0.id]
        }
        session.transferUserInfo(["todos" : seriliazed])
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        guard let id = userInfo["id"] as? String else {
            // Not valid request
            return
        }
        
        Todos.deleteTodoWithId(id)
    }
}