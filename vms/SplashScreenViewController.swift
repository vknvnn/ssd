//
//  SplashScreenViewController.swift
//  vms
//
//  Created by NghiepVo on 11/5/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let signInService = SignInService()
        if signInService._refreshToken != nil {
            signInService.RefreshToken(viewController: self, taskCallback: {(isError: Bool, responseObject:NSDictionary?) in
                print(isError, responseObject as Any)
                if isError
                {
                    if (responseObject?["error"] as! String == "invalid_grant"){
                        signInService.alert(viewController: self, message: "Your session was timeout. Please login", okCallback: {() in
                            self.perform(#selector(self.showLoginController), with: nil);
                        })
                    }
                }
                else {
                    self.perform(#selector(self.showDashboardController), with: nil)
                }
            })
        }
        else {
            self.perform(#selector(self.showLoginController), with: nil, afterDelay: 1);
        }
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func showLoginController() {
        self.performSegue(withIdentifier: "GoLoginScreen", sender: self)
    }
    
    func showDashboardController() {
        self.performSegue(withIdentifier: "GoDashboard", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
