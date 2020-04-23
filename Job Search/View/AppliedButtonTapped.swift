//
//  AppliedButtonTapped.swift
//  Job Search
//
//  Created by JASJEEV on 4/23/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit
protocol OptionButtonsDelegate{
    func closeFriendsTapped(at index:IndexPath)
}
class AppliedButtonsTableViewCell: UITableViewCell {
    var delegate:OptionButtonsDelegate!
    @IBOutlet weak var closeFriendsBtn: UIButton!
    var indexPath:IndexPath!
    @IBAction func closeFriendsAction(_ sender: UIButton) {
        self.delegate?.closeFriendsTapped(at: indexPath)
    }
}
