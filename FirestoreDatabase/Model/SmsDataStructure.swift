//
//  SmsDataStructure.swift
//  FirestoreDatabase
//
//  Created by Admin on 23/03/22.
//

import Foundation

enum VerifyError: Error {
    case invalidUrl
    case err(String)
}

protocol WithMessage {
    var message : String { get }
}

enum VarifyResult {
    case success(WithMessage)
    case failure(Error)
}

class DataResult : WithMessage {
    let data : Data
    let message : String
    
    
    init (data : Data) {
        self.data = data
        self.message = String(describing: data)
    }
    
    
}
struct CheckResult : Codable, WithMessage {
    let success : Bool
    let message: String
}
