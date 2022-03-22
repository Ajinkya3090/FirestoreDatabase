//
//  ProfileTableViewCell.swift
//  FirestoreDatabase
//
//  Created by Admin on 03/03/22.
//

import UIKit


class ProfileTableViewCell: UITableViewCell {

    //weak var delegate : ProfileData?
    var viewModel: ValidationFields?
    
    @IBOutlet weak var tF_Name: UITextField!
    @IBOutlet weak var tF_Email: UITextField!
    @IBOutlet weak var tF_ContactNo: UITextField!
    @IBOutlet weak var tF_Password: UITextField!
    @IBOutlet weak var btn_Save: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func save_Btn_Action(_ sender: Any) {
        self.viewModel = ValidationFields()
        let userData = ProfileData(name: tF_Name.text!, emailId: tF_Email.text!, contactNumber: tF_ContactNo.text!, password: tF_Password.text!)
        guard let validateData = ValidationFields.validateSignInInput(validation:userData)else {return }
        viewModel?.uploadDataToFirestore(data: validateData, comlisherHandler: {
            print("Data upload Successful")
            //      self.updateData()
        }, failed: {
            print("Data upload Un-Successful")
        })
    }
}
