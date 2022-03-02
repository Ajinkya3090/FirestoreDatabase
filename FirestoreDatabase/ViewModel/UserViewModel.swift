//
//  File.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
class ValidationFields {
    
    let firestoreDB = Firestore.firestore()
    
    var users = [ProfileData]()
    
    static func validateSignInInput(validation : ProfileData) ->ProfileData? {
        guard let name = validation.name else {return nil }
        guard let emailId = validation.emailId else { return nil}
        guard let contactNumber = validation.contactNumber else { return nil}
        guard let password = validation.password else { return nil}
        if name.isEmpty || emailId.isEmpty || contactNumber.isEmpty || password.isEmpty {
            return nil
        }else{
            let userData = ProfileData(name: name, emailId: emailId, contactNumber: contactNumber, password: password)
            return userData
        }
    }
    
    func uploadDataToFirestore(data:ProfileData ,comlisherHandler: @escaping ()->(), failed: @escaping ()->()) {
        
        let docRef = firestoreDB.collection("User").document(data.name!)
        
        docRef.setData(["Name" : data.name, "Email" : data.emailId, "Contact Number" : data.contactNumber, "Password" : data.password]) { error in
            if error == nil {
                comlisherHandler()
            } else {
                print(error?.localizedDescription)
                failed()
            }
        }
        
    }
    
    func getDataFromFirestore(comlisherHandler: @escaping ()->()) {
        users.removeAll()
        let docRef = firestoreDB.collection("User")
        docRef.getDocuments { [weak self] snapshot, error in
            if error == nil {
                guard let data = snapshot else { return }
                for document in data.documents {
                    let userData  = document.data()
                    guard let name = userData["Name"] as? String else {return}
                    guard let emailId = userData["Email"] as? String else {return}
                    guard let contactNumber = userData["Contact Number"] as? String else {return}
                    guard let password = userData["Password"] as? String else {return}
                    let user = ProfileData(name: name, emailId: emailId, contactNumber: contactNumber, password: password)
                    self?.users.append(user)
                    comlisherHandler()
                }
            }
        }
    }
}
