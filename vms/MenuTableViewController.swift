//
//  MenuTableViewController.swift
//  vms
//
//  Created by NghiepVo on 11/8/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    @IBOutlet var rowSignOut: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row:UITableViewCell = self.tableView.cellForRow(at: indexPath)!
        if row == rowSignOut {
            signOut()
        }
    }
    
    func signOut() {
        let alert = UIAlertController(title: "360 VMS", message: "Do you want to Sign Out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            DataProvider().clearLoginInfo()
            self.perform(#selector(self.showLoginController), with: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoginController() {
        self.performSegue(withIdentifier: "GoSignOutToLogin", sender: self)
    }
}
