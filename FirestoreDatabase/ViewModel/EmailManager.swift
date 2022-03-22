//
//  EmailManager.swift
//  FirestoreDatabase
//
//  Created by Admin on 14/03/22.
//

import Foundation
import SendGrid
import SDWebImage
import Loaf

protocol emailSentSuccessfully:AnyObject {
    func emailUpdate(isSuccess: Bool)
}


struct EmailManager{
    
    weak var delelgate: emailSentSuccessfully?
    
    func WelcomingEmail (fullname : String, email : String)-> Void {
        
        
        let apiKey = "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"
        let name = fullname
        let email = email
        let devloperEmail = "ajinkyaa@bipp.io"
        
        let data : [String : String] = [
            "name" : name,
            "user" : email
        ]
        
        let personalization = TemplatedPersonalization(dynamicTemplateData: data, recipients: email)
        let session = Session()
        session.authentication = Authentication.apiKey(apiKey)
        
        let from = Address(email: devloperEmail,name: name)
        
        let templete = Email(personalizations: [personalization], from: from, templateID: "d-414fc373334e4c7ba8136411894b0187")
        
        do {
            try session.send(request: templete, completionHandler: { (result) in
                switch result {
                case .success(let response) :
                    delelgate?.emailUpdate(isSuccess: true)
                    print("response: \(response.statusCode)")
                    
                    
                case .failure(let error):
                    delelgate?.emailUpdate(isSuccess: false)
                    print("error : \(error.localizedDescription)")
                    //completion(.failure(error))
                }
            })
        } catch(let error) {
            print("error : \(error.localizedDescription)")
            //completion(.failure(error))
            delelgate?.emailUpdate(isSuccess: false)
        }
    }
    
}

