//
//  ViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    var user = ValidationFields()
    
    @IBOutlet weak var tf_Name: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_ContactNumber: UITextField!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var btn_AddNewsUser: UIButton!
    @IBOutlet weak var view_tblView: UITableView!
    @IBOutlet weak var viewOutlet: UIView!
    
    var viewModel: ValidationFields?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ValidationFields()
        // self.updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.getdataFrmFirebase {
            self.view_tblView.reloadData()
        }
    }
    //    func updateData() {
    //        viewModel?.getDataFromFirestore {
    //            DispatchQueue.main.async {
    //                self.tblView.reloadData()
    //            }
    //        }
    //    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let userData = ProfileData(name: tf_Name.text!, emailId: tf_Email.text!, contactNumber: tf_ContactNumber.text!, password: tf_Password.text!)
        guard let validateData = ValidationFields.validateSignInInput(validation:userData)else {return }
        viewModel?.uploadDataToFirestore(data: validateData, comlisherHandler: {
            print("Data upload Successful")
            //      self.updateData()
        }, failed: {
            print("Data upload Un-Successful")
        })
        if viewOutlet.tag == 0 {
            viewOutlet.tag = 1
            viewOutlet.isHidden = true
        }
    }
    
    @IBAction func newUserAction(_ sender: Any) {
        if viewOutlet.tag == 1 {
            viewOutlet.tag = 0
            viewOutlet.isHidden = false
            
            tf_Name.text = ""
            tf_Email.text = ""
            tf_ContactNumber.text = ""
            tf_Password.text = ""
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = view_tblView.dequeueReusableCell(withIdentifier: "DisplayTableViewCell", for : indexPath) as? DisplayTableViewCell {
            guard let user = viewModel?.users[indexPath.row] else {return UITableViewCell()}
            cell.fetchData(data: user)
            return cell
        }
        return UITableViewCell()
    }
}
