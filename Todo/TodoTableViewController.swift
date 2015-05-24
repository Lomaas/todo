//
//  ViewController.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    var tableData = [Todo]()
    
    @IBAction func didPressAddNewTodo(sender: AnyObject) {
        println("addnewTodo")
        performSegueWithIdentifier("goToTodoViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableData = Todos.get().todos
        tableView.reloadData()
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
        }
    }
}

extension TodoTableViewController: TodoViewControllerProtocol {
    func didAddNewTodo() {
        navigationController?.popViewControllerAnimated(true)
    }
}

