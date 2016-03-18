//
//  ViewController.swift
//  HitList
//
//  Created by liudong on 16/3/18.
//  Copyright © 2016年 liudong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()//[String]()
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            people = fetchedResults
            
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The List"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.dataSource = self
        
    }
    
    @IBAction func addName(sender: AnyObject) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) in
            
            let textField = alert.textFields![0] as UITextField
            self.saveName(textField.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action:UIAlertAction) in

        }
        
        alert.addTextFieldWithConfigurationHandler({ (textField:UITextField) in
            
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(name:String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        
//        var error:NSError?
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        people.append(person)
        
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.valueForKey("name") as? String
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

