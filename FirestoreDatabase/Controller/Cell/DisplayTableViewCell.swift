//
//  DisplayTableViewCell.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_ContactNumber: UILabel!
    @IBOutlet weak var lbl_Password: UILabel!
    
    func fetchData(data : ProfileData) {
        if let name = data.name {
            lblName.text = "Name: \(name)"
        } else {
            lblName.isHidden = true
        }
        if let email = data.emailId {
            lbl_Email.text = "Email: \(email)"
        } else {
            lbl_Email.isHidden = true
        }
        if let contact = data.contactNumber {
            lbl_ContactNumber.text = "Contact Number: \(contact)"
        } else {
            lbl_ContactNumber.isHidden = true
        }
        if let password = data.password {
            lbl_Password.text = "Password: \(password)"
        } else {
            lbl_Password.isHidden = true
        }
    }
}
