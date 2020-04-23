//
//  TableCellView.swift
//  Job Search
//
//  Created by JASJEEV on 4/21/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit

protocol ProgressButtonsDelegate{
    func applyTapped(at index:IndexPath)
}

internal final class TableCellView: UITableViewCell{
    //@IBOutlet weak var companyImage: UIImageView!
    var indexPath:IndexPath!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var applied: UIButton!
    @IBOutlet weak var interview: UIButton!
    @IBOutlet weak var offerRecieved: UIButton!
    var delegate: ProgressButtonsDelegate!
    
    @IBAction func applyButtonTap(_ sender: Any) {
        self.delegate?.applyTapped(at: indexPath)
    }
    
}
