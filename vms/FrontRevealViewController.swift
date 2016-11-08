//
//  FrontRevealViewController.swift
//  vms
//
//  Created by NghiepVo on 11/8/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import UIKit

class FrontRevealViewController: ViewController {
let loading = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loading.showActivityIndicator(uiView: self.view);
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {action in
            self.loading.hideActivityIndicator(uiView: self.view)
            self.perform(#selector(self.showDashboardController), with: nil)
        })
    }
    
    func showDashboardController() {
        self.performSegue(withIdentifier: "GoFrontToDashboard", sender: self)
    }
    
    func showTimeClockController() {
        self.performSegue(withIdentifier: "GoFrontToTimeClock", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
