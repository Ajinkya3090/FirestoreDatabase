//
//  XibTableViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 03/03/22.
//

import UIKit

class XibTableViewController: UIViewController {

    @IBOutlet weak var tblViewController: UITableView!
    var viewModel: ValidationFields?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblViewController.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
       
        self.tblViewController.register(UINib(nibName: "DataPresentTableViewCell", bundle: nil), forCellReuseIdentifier: "DataPresentTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel = ValidationFields()
        viewModel?.getdataFrmFirebase {
            self.tblViewController.reloadData()
        }
    }

}

    
extension XibTableViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0{
             return 1
         }else {
             return self.viewModel?.users.count ?? 0
         }
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if indexPath.section == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath)as! ProfileTableViewCell
             return cell
         }else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "DataPresentTableViewCell", for: indexPath)as! DataPresentTableViewCell
             guard let user = viewModel?.users[indexPath.row] else {return UITableViewCell()}
             cell.fetchData(data: user)
             return cell
         }
        
    }
}
