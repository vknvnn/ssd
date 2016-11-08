//
//  TimeClockViewController.swift
//  vms
//
//  Created by NghiepVo on 11/8/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import UIKit

class TimeClockViewController: ViewController {

    @IBOutlet var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().tapGestureRecognizer().isEnabled = false;
            self.revealViewController().panGestureRecognizer().isEnabled = false;
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
