//
//  ViewController.swift
//  vms
//
//  Created by NghiepVo on 11/5/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    let heightViewLogin:CGFloat = 250
    
    var textFieldSelected:UITextField? = nil
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let signInService = SignInService()
    
    @IBOutlet var viewSignIn: UIView!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var MarginTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setHeightWhenTransition(height: UIScreen.main.bounds.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setHeightWhenTransition(height: size.height)
        if textFieldSelected != nil {
            textFieldSelected!.resignFirstResponder()
        }
    }
    
    func setHeightWhenTransition(height: CGFloat){
        let hight = (height - heightViewLogin)/2
        MarginTop.constant = hight
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: textField, up: true)
        textFieldSelected = textField;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        moveTextField(textField: textField, up: false)
        textFieldSelected = nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textFieldSelected = nil
        if (textField == self.txtUserName) {
            self.txtPassword.becomeFirstResponder();
        }
        else {
            textField.resignFirstResponder()
            login()
        }
        return true;
    }
    
    @IBAction func touchUpInsideSignIn(_ sender: Any) {
        if textFieldSelected != nil {
            textFieldSelected!.resignFirstResponder()
        }        
        login()
    }
    
    func login() {
        signInService.signIn(viewController: self, userName: txtUserName.text!, password: txtPassword.text!, taskCallback: {(isError: Bool, responseObject:NSDictionary?) in
            if !isError {
                self.perform(#selector(self.showDashboardController), with: nil)
            }
        })
    }
    
    func showDashboardController() {
        self.performSegue(withIdentifier: "GoLoginToDashboard", sender: self)
    }
    func moveTextField(textField: UITextField, up: Bool) {
        let keyboardHeight:CGFloat = 250
        let moveDuration = 0.3
        let positionYTextField:CGFloat = getPositionYTextField(textField: textField)
        let moveDistance = keyboardHeight - (UIScreen.main.bounds.height - positionYTextField - 35);
        
        if (moveDistance > 0) {
            let movement: CGFloat = up ? -moveDistance: moveDistance
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(moveDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        }
    }
    
    func getPositionYTextField(textField: UITextField) -> CGFloat {
        var result = textField.frame.origin.y
        if textField.superview != nil {
            result += textField.superview!.frame.origin.y;
        }
        return result
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

