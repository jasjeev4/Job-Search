//
//  NewJobViewController.swift
//  Job Search
//
//  Created by JASJEEV on 4/21/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewJobViewController: UIViewController {
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var jobRole: UITextField!
    
    var jobList: [NSManagedObject] = []
    
    @IBAction func onBackButtonPress(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if(jobTitle.text == "") {
            alert(title: "No Job Title", message: "")
        }
        else if(jobRole.text == "") {
            alert(title: "No Job Role", message: "")
        }
        else {
            // Load image url
            Client.loadLogo(company: jobTitle.text!, completion: handleLogoResponse(photoURL:error:))
        }
    }
    
    func handleLogoResponse(photoURL: String, error: Error?) {
    
        if (error != nil) {
            print("There was an error")
        }
        else {
            // Save to store
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Job", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(jobTitle.text, forKeyPath: "title")
            person.setValue(jobRole.text, forKeyPath: "role")
            person.setValue(Date(), forKeyPath: "creationDate")
            person.setValue(photoURL, forKeyPath: "photoURL")
            person.setValue(false, forKeyPath: "applied")
            person.setValue(false, forKeyPath: "interview")
            person.setValue(false, forKeyPath: "offer")
            
            do {
              try managedContext.save()
              jobList.append(person)
                
              //back to previoud view
              _ = navigationController?.popViewController(animated: true)
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    func alert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
