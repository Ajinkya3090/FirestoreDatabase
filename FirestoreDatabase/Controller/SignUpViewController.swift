//
//  SignUpViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 09/03/22.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPswd: UITextField!
    @IBOutlet weak var btnSignUpAcc: UIButton!
    
    private var emailManager = EmailManager()
    var userEP = EmailPassword()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailManager.delelgate = self
    }
    
    @IBAction func btnToAccount(_ sender: Any) {
        let file = ProfileData(name: tfName.text ?? "" , emailId: tfEmail.text ?? "" , contactNumber: "", password: tfPswd.text ?? "" )
        if let data = EmailPassword.validateSignInInput(validation: file) {
            userEP.registerNewUser(withEmail: data.emailId! , password: data.password!, name: data.name!) { [unowned self] in
                self.emailManager.WelcomingEmail(fullname: data.name ?? "", email: data.emailId!)
            } failed: { [weak self]error in
                self?.showAlert(title: "Warning", message: error)
            }
        } else {
            self.showAlert(title: "Warning", message: "Enter valid data in Details!")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SignUpViewController: emailSentSuccessfully{
    func emailUpdate(isSuccess: Bool) {
        if isSuccess{
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            print("Failed to send email!")
        }
    }
}
