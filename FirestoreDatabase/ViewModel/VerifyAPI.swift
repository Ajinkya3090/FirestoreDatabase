//
//  VerifyAPI.swift
//  FirestoreDatabase
//
//  Created by Admin on 23/03/22.
//

import Foundation


struct VerifyAPI {
    static func sendVerification (_ countryCode : String,
                                  _ phoneNumber : String ) {
        let parameter = [
            "via" : "sms",
            "country_Code" : countryCode,
            "phone_Number" : phoneNumber
        ]
        RequestHelper.createRequest("start", parameter) { json in
            return .success(DataResult(data: json))
        }
    }
    
    static func validateVarificationCode (_ countryCode : String,
                                          _ phoneNumber : String,
                                          _ code : String,
                                          completionHandler : @escaping (CheckResult) -> Void) {
        let parameters = [
            "via" : "sms",
            "country_code" : countryCode,
            "phone_Number" : phoneNumber,
            "verification_code" : code
        ]
        
        RequestHelper.createRequest("check", parameters) {
            jsonData in
            
            let decoder = JSONDecoder()
            do {
                let checked = try decoder.decode(CheckResult.self, from: jsonData)
                DispatchQueue.main.async {
                    completionHandler(checked)
                }
                return VarifyResult.success(checked)
            } catch {
                return VarifyResult.failure(VerifyError.err("Failed to Deserialize"))
            }
        }
    }
}
