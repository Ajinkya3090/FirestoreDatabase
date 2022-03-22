//
//  LogInViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 09/03/22.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    var userEP = EmailPassword()
    
    @IBOutlet weak var tfEmailId: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TranslatorViewModel().translateText(text: "Hello")
    }
    
    @IBAction func btnLogIn(_ sender: Any) {
        let logedIn = UserDefaults.standard.string(forKey: "userName")
        
        let file = ProfileData(name: "", emailId: tfEmailId.text ?? "", contactNumber: "", password: tfPassword.text ?? "")
        guard let data =  EmailPassword.validateSignInInput(validation: file ) else {return}
        userEP.loginUser(withEmail: data.emailId!, password: data.password!, failed: { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Warning", message: "Invalid Credentials! Try again.")
            }
        }) {[unowned self] in
            DispatchQueue.main.async {
                Analytics.logEvent("loginEventFBase", parameters: [
                    AnalyticsEventLogin : "\(logedIn) logedIn Successfully"])
                if let firebaseStorageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirebaseStorageViewController") as? FirebaseStorageViewController {
                    self.navigationController?.pushViewController(firebaseStorageViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        if let firebaseStorageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirebaseStorageViewController") as? FirebaseStorageViewController {
            self.navigationController?.pushViewController(firebaseStorageViewController, animated: true)
        }
    }
    
    @IBAction func btnSignup(_ sender: Any?) {
        let newUserName = UserDefaults.standard.string(forKey: "userName")
        Analytics.logEvent("NewUserAddedToFBase" , parameters: [
            AnalyticsParameterSuccess : "New User added Successfully \(newUserName)"])
        if let signUpViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpViewControllerObj, animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
