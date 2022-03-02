//
//  ViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import UIKit

class ViewController: UIViewController {

    var user = ValidationFields()
    
    @IBOutlet weak var name_TF: UITextField!
    @IBOutlet weak var email_TF: UITextField!
    @IBOutlet weak var contactNumber_TF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var password_TF: UITextField!
    @IBOutlet weak var addNewUserBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    
    var viewModel: ValidationFields?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ValidationFields()
        self.updateData()
    }
    
    func updateData() {
        viewModel?.getDataFromFirestore {
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        let userData = ProfileData(name: name_TF.text!, emailId: email_TF.text!, contactNumber: contactNumber_TF.text!, password: password_TF.text!)
        guard let validateData = ValidationFields.validateSignInInput(validation:userData)else {return }
        viewModel?.uploadDataToFirestore(data: validateData, comlisherHandler: {
            print("Data upload Successful")
            self.updateData()
        }, failed: {
            print("Data upload Un-Successful")

        })
       
        
        
    }
    
    @IBAction func newUserAction(_ sender: Any) {
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblView.dequeueReusableCell(withIdentifier: "DisplayTableViewCell", for : indexPath) as? DisplayTableViewCell {
            guard let user = viewModel?.users[indexPath.row] else {return UITableViewCell()}
            cell.fetchData(data: user)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
