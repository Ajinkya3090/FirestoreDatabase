//
//  Email&PasswordAuth.swift
//  FirestoreDatabase
//
//  Created by Admin on 09/03/22.
//

import Foundation
import Firebase


class EmailPassword  {
    
    var users = [ProfileData]()
    private(set) var user: User?
    
    static func validateSignInInput(validation : ProfileData) ->ProfileData? {
        guard let name = validation.name else {return nil }
        guard let emailId = validation.emailId else { return nil }
        guard let contactNumber = validation.contactNumber else { return nil }
        guard let password = validation.password else { return nil }
        if emailId.isEmpty || password.isEmpty {
            return nil
        }else{
            let userData = ProfileData(name: name, emailId: emailId, contactNumber: contactNumber, password: password)
            return userData
        }
    }
    
    func registerNewUser(withEmail email: String, password: String, name: String, complesherHandler:@escaping ()->(),failed: @escaping(String)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] auth, error in
            if error == nil {
                let changeRequest = auth?.user.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { [weak self] error in
                    print("New Account Created")
                    self?.user = auth?.user
                    complesherHandler()
                }
            } else {
                print(error!.localizedDescription)
                failed(error!.localizedDescription)
            }
        }
    }
    
    func loginUser(withEmail email: String, password: String, failed:@escaping ()->() ,complesherHandler:@escaping ()->()) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] auth, error in
            if error == nil {
                print("Successful Login")
                self?.user = auth?.user
                UserDefaults.standard.set(auth?.user.displayName, forKey: "userName") 
                complesherHandler()
            } else {
                print(error!.localizedDescription)
                failed()
            }
        }
    }
}
