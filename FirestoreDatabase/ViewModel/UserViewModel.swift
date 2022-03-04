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
import FirebaseStorage

protocol GetImage: AnyObject {
    func updateCollection()
}

class ValidationFields {
    
    var firestoreDB = Firestore.firestore()

    let storageRefernce = Storage.storage().reference()
    
    var users = [ProfileData]()
    
    weak var delegate: GetImage?
    
    var imageArr: [Data] = [Data]() {
        didSet {
            self.delegate?.updateCollection()
        }
    }
    
    
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
        
        let uploadData = firestoreDB.collection("User").document(data.name!)
        
        uploadData.setData(["Name" : data.name ?? "", "Email" : data.emailId ?? "", "Contact Number" : data.contactNumber ?? "", "Password" : data.password ?? ""]) { error in
            if error == nil {
                comlisherHandler()
            } else {
                print(error!.localizedDescription)
                failed()
            }
        }
        
    }
    
    //    func getDataFromFirestore(comlisherHandler: @escaping ()->()) {
    //        users.removeAll()
    //        let getData = firestoreDB.collection("User")
    //        getData.getDocuments { [weak self] snapshot, error in
    //            if error == nil {
    //                guard let data = snapshot else { return }
    //                for document in data.documents {
    //                    let userData  = document.data()
    //                    guard let name = userData["Name"] as? String else {return}
    //                    guard let emailId = userData["Email"] as? String else {return}
    //                    guard let contactNumber = userData["Contact Number"] as? String else {return}
    //                    guard let password = userData["Password"] as? String else {return}
    //                    let user = ProfileData(name: name, emailId: emailId, contactNumber: contactNumber, password: password)
    //                    self?.users.append(user)
    //                    comlisherHandler()
    //                }
    //            }
    //        }
    //    }
    
    func getdataFrmFirebase(completed: @escaping ()->()) {
        firestoreDB.collection("User").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return completed()
            }
            self.users = []
            for document in querySnapshot!.documents {
                let profile = ProfileData(dictionary: document.data())
                self.users.append(profile)
                completed()
            }
            
        }
    }
    
    func dwnloadImgFrmStorage() {
        storageRefernce.child("Image").listAll { storageRef, error in
            for image in storageRef.items {
                let path = image.fullPath
                print(image.fullPath)
                self.storageRefernce.child(path).downloadURL { url, err in
                    guard let url = url else {
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url) { data, respo, err in
                        DispatchQueue.main.async {
                            guard let data = data else {
                                return
                            }
                            self.imageArr.append(data)
                        }
                    }.resume()
                }
            }
        }
    }
}


