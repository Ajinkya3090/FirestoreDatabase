//
//  DataPresentTableViewCell.swift
//  FirestoreDatabase
//
//  Created by Admin on 03/03/22.
//

import UIKit

class DataPresentTableViewCell: UITableViewCell {
    
    var viewModel: ValidationFields?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
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
            lblContactNo.text = "Contact Number: \(contact)"
        } else {
            lblContactNo.isHidden = true
        }
        if let password = data.password {
            lblPassword.text = "Password: \(password)"
        } else {
            lblPassword.isHidden = true
        }
    }
}
