//
//  ViewController.swift
//  Job Search
//
//  Created by JASJEEV on 4/21/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
       var jobList: [NSManagedObject] = []
       var fetchedResultsController:NSFetchedResultsController<Job>!
    
    @IBAction func onSortChange(_ sender: Any) {
        let alert = UIAlertController(title: "Change sort", message: "Do you want sort from recent or oldest?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Recent", style: .default, handler: { action in
            UserDefaults.standard.set(true, forKey: "sortByRecent")
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Job")
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]

            do {
                self.jobList = try managedContext.fetch(fetchRequest)
                self.tableView.reloadData()
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Oldest", style: .default, handler: { action in
           UserDefaults.standard.set(false, forKey: "sortByRecent")
            
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                      }

                      let managedContext = appDelegate.persistentContainer.viewContext
                      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Job")
                      let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
                      fetchRequest.sortDescriptors = [sortDescriptor]

                      do {
                          self.jobList = try managedContext.fetch(fetchRequest)
                          self.tableView.reloadData()
                      } catch let error as NSError {
                        print("Could not fetch. \(error), \(error.userInfo)")
                      }
        }))
        
        self.present(alert, animated: true)
    }


    @IBAction func onNewJob(_ sender: Any) {
        // Perform segue to New Job
        performSegue(withIdentifier: "toNewJob", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sortByAscending = UserDefaults.standard.bool(forKey: "sortByRecent")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Job")
        
        if(sortByAscending) {
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        
        do {
          jobList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Refresh table contents on view load
        tableView.reloadData()
    }
        
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = jobList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCellView

        print("Date: ")
        print(person.value(forKeyPath: "creationDate"))
        
        // Configure cell
        cell.company.text = person.value(forKeyPath: "title") as? String
        cell.role.text = person.value(forKeyPath: "role") as? String
            
        
        let photoURL =  person.value(forKeyPath: "photoURL") as? String
        
        //load image
        Client.downloadPhoto(urlString: photoURL!) { (image, error) in
           guard let image = image else {
               return
           }
           cell.photo.image = image
        }
        return cell
    }
	
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0;//Choose your custom row height
    }
    
    
}
