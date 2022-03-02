//
//  DisplayTableViewCell.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contactNumberLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    
    
    func fetchData(data : ProfileData) {
        
        nameLbl.text = "Name: \(data.name!)"
        emailLbl.text = "Email: \(data.emailId!)"
        contactNumberLbl.text = "Contact Number: \(data.contactNumber!)"
        passwordLbl.text = "Password: \(data.password!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
