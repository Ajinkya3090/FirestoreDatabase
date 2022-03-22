//
//  DataPresentTableViewCell.swift
//  FirestoreDatabase
//
//  Created by Admin on 03/03/22.
//

import UIKit

class DataPresentTableViewCell: UITableViewCell {
    
    var viewModel: ValidationFields?
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_ContactNo: UILabel!
    @IBOutlet weak var lbl_Password: UILabel!
    
    func fetchData(data : ProfileData) {
        if let name = data.name {
            lbl_Name.text = "Name: \(name)"
        } else {
            lbl_Name.isHidden = true
        }
        if let email = data.emailId {
            lbl_Email.text = "Email: \(email)"
        } else {
            lbl_Email.isHidden = true
        }
        if let contact = data.contactNumber {
            lbl_ContactNo.text = "Contact Number: \(contact)"
        } else {
            lbl_ContactNo.isHidden = true
        }
        if let password = data.password {
            lbl_Password.text = "Password: \(password)"
        } else {
            lbl_Password.isHidden = true
        }
    }
}
