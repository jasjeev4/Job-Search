//
//  NewJobViewController.swift
//  Job Search
//
//  Created by JASJEEV on 4/21/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit

class NewJobViewController: UIViewController {
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var jobRole: UITextField!
    
    var dataController:DataController!
    
    @IBAction func onBackButtonPress(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if(jobTitle.text == "") {
            alert(title: "No Job Title", message: "")
        }
        else if(jobRole.text == "") {
            alert(title: "No Job Role", message: "")
        }
        else {
            // Save to store
            let job = Job(context: dataController.viewContext)
            job.title = jobTitle.text
            job.role = jobRole.text
            job.creationDate = Date()
            job.applied = false
            job.interview = false
            job.offer = false
            
            try? dataController.viewContext.save()
        }
    }
    
    func alert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
