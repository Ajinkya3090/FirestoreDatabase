//
//  DisplayTableViewCell.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    func fetchData(data : ProfileData) {
        
        if let name = data.name {
            lblName.text = "Name: \(name)"
        } else {
            lblName.isHidden = true
        }
        if let email = data.emailId {
            lblEmail.text = "Email: \(email)"
        } else {
            lblEmail.isHidden = true
        }
        if let contact = data.contactNumber {
            lblContactNumber.text = "Contact Number: \(contact)"
        } else {
            lblContactNumber.isHidden = true
        }
        if let password = data.password {
            lblPassword.text = "Password: \(password)"
        } else {
            lblPassword.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
