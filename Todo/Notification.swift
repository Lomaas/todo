import Foundation

class Notification {
    static private let ITEMS_KEY = "notifications"
    var id: String
    var date: NSDate
    
    init(id: String, date: NSDate) {
        self.id = id
        self.date = date
    }
    
    func setShowedNotification() {
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(Notification.ITEMS_KEY) ?? Dictionary()
        todoDictionary[id] = ["id" : id, "date" : date]
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: Notification.ITEMS_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func getShowedNotifications() -> [Notification] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map { Notification(id: $0["id"] as! String, date: $0["date"] as! NSDate) }
    }
    
    static func deleteNotification(id: String) {
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(Notification.ITEMS_KEY) ?? Dictionary()
        todoDictionary.removeValueForKey(id)
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: Notification.ITEMS_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()        
    }
}