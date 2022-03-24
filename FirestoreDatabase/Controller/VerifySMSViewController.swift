//
//  VerifySMSViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 23/03/22.
//

import UIKit

class VerifySMSViewController: UIViewController {

    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var tfVerifyCode: UITextField!
    
    var countryCode : String?
    var phoneNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()



    }
    @IBAction func btnValidateCode(_ sender: Any) {
        //self.lblstatus = nil
        self.lblstatus.isHidden = true
        
        if let code = tfVerifyCode.text {
            VerifyAPI.validateVarificationCode(self.countryCode!, self.phoneNumber!, code) {
                checked in
                
                if (checked.success) {
                    self.lblstatus.textColor = UIColor.green
                    self.lblstatus.text = "Verification Completed"
                    self.lblstatus.isHidden = false
                } else {
                    self.lblstatus.textColor = UIColor.red
                    self.lblstatus.text = checked.message
                    self.lblstatus.isHidden = false
                }
            }
        }
    }
    

}
