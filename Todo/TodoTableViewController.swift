import UIKit

class TodoTableViewController: UITableViewController {
    var tableData = [Todo]()
    let appleWatchCommunicator = AppleWatchCommunicator()
    
    @IBAction func didPressAddNewTodo(sender: AnyObject) {
       performSegueWithIdentifier("goToTodoViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleRefreshTableView", name: "handleRefreshTableView", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        handleRefreshTableView()
    }
    
    func handleRefreshTableView() {
        tableData = Todos.get().todos
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToTodoViewController" {
            let vc = segue.destinationViewController as! TodoViewController
            vc.delegate = self
            if let todo = sender as? Todo {
                vc.todo = todo
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("goToTodoViewController", sender: tableData[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell") as! TodoTableViewCell
        let todo = tableData[indexPath.row]
        cell.title.text = todo.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let todo = tableData[indexPath.row]
            tableData.removeAtIndex(indexPath.row)
            tableView.reloadData()
            Todos.deleteTodoWithId(todo.id)
            Notification.deleteNotification(todo.id)
            appleWatchCommunicator.sendRecentUpdate()
        }
    }
}

extension TodoTableViewController: TodoViewControllerProtocol {
    func didAddNewTodo() {
        navigationController?.popViewControllerAnimated(true)
        appleWatchCommunicator.sendRecentUpdate()
    }
}

