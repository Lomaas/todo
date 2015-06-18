import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    let session = WCSession.defaultSession()

    @IBOutlet weak var tableView: WKInterfaceTable!
    @IBOutlet var myLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        session.delegate = self
        session.activateSession()
        print("Context: \(context)")
        myLabel.setText("faslkfjsk")
        
        session.transferUserInfo(["id" : "64AB925F-0D41-4F12-B57F-2A93BAFA44E3"])
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        myLabel.setText("inside didrecei")
        
        guard let todos = userInfo["todos"] as? [[String : AnyObject]] else {
            return
        }
        let id = todos[0]["id"] as? String ?? "funket ikke"
        print("ID: \(id)")
        myLabel.setText(id)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
