//
//  File.swift
//  FirestoreDatabase
//
//  Created by Admin on 02/03/22.
//

import Foundation

class ProfileData {
    var name : String?
    var emailId : String?
    var contactNumber : String?
    var password : String?
    
    
    
    init(name: String, emailId: String, contactNumber: String, password: String){
        self.name = name
        self.emailId = emailId
        self.contactNumber = contactNumber
        self.password = password
    }
    
    convenience init (dictionary: [String : Any]) {
        let name = dictionary["Name"] as! String? ?? ""
        let emailId = dictionary["Email"] as! String? ?? ""
        let contactNumber = dictionary["Contact Number"] as! String? ?? ""
        let password = dictionary["Password"] as! String? ?? ""
        
        self.init(name: name, emailId: emailId, contactNumber: contactNumber, password: password)
    }
}
