//
//  SignInService.swift
//  vms
//
//  Created by NghiepVo on 11/7/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import Foundation
import UIKit

class SignInService: DataProvider {
    
    private func validation(viewController: UIViewController, userName: String, password:String) -> Bool {
        var result:Bool = true;
        
        var msg  = "\n"
        if userName == "" {
            msg = msg + "The Username field is required. \n"
            result = false;
        }
        if (password == "") {
            msg = msg + "The Password field is required. \n"
            result = false;
        }
        if !result {
            let alert = UIAlertController(title: "360 VMS - Validation", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            
            }))
            viewController.present(alert, animated: true, completion: nil)
        }
        return result;
    }
    
    public func signIn(viewController: UIViewController, userName: String, password: String, taskCallback: @escaping(Bool, NSDictionary?) -> ()){
        
        if (!validation(viewController: viewController, userName: userName, password: password)) {
            return;
        }
        
        let todoEndpoint: String = _urlApi + "token";
        
        guard let urlResult = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: urlResult)
        urlRequest.httpMethod = "POST";
        let postString = "grant_type=password&username=\(userName)&password=\(password)&time_zone_offset=\(getTimeZone())&client_id=\(_clientId)&client_secret=\(_clientSecret)"
        
        urlRequest.httpBody = postString.data(using: .utf8)
        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        self._loading.showActivityIndicator(uiView: viewController.view)
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling \(todoEndpoint)")
                DispatchQueue.main.async(){
                    taskCallback(true, nil)
                    self._loading.hideActivityIndicator(uiView: viewController.view)
                }
                return
            }
            let httpStatus = response as? HTTPURLResponse
            if httpStatus!.statusCode == 200
            {
                if data!.count != 0 {
                    let responseString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    DispatchQueue.main.async(){
                        self.saveLoginInfo(data: responseString!)
                        self.getLoginInfo()
                        taskCallback(false, responseString)
                        self._loading.hideActivityIndicator(uiView: viewController.view)
                    }
                    return;
                    
                }
                else {
                    print("No data got from Url!")
                }
            }
            else {
                print("Error httpstatus code is: \(httpStatus!.statusCode)")
                if data!.count != 0 {
                    let responseString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    DispatchQueue.main.async(){
                        taskCallback(true, nil)
                        self._loading.hideActivityIndicator(uiView: viewController.view)
                        self.alert(viewController: viewController, message: responseString!["error_description"] as! String)
                    }
                    return;
                    
                }
            }
            DispatchQueue.main.async(){
                taskCallback(true, nil);
                self._loading.hideActivityIndicator(uiView: viewController.view)
            }
            return;
            
        }        
        task.resume()
    }
    
    public func RefreshToken(viewController: UIViewController, taskCallback: @escaping(Bool, NSDictionary?) -> ()) {
        let todoEndpoint: String = _urlApi + "token";
        
        guard let urlResult = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: urlResult)
        urlRequest.httpMethod = "POST";
        let postString = "grant_type=refresh_token&refresh_token=\(_refreshToken!)&time_zone_offset=\(getTimeZone())&client_id=\(_clientId)&client_secret=\(_clientSecret)"
        
        urlRequest.httpBody = postString.data(using: .utf8)
        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling \(todoEndpoint)")
                DispatchQueue.main.async(){
                    taskCallback(true, nil)
                }
                return
            }
            let httpStatus = response as? HTTPURLResponse
            if httpStatus!.statusCode == 200
            {
                if data!.count != 0 {
                    let responseString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    DispatchQueue.main.async(){
                        self.saveLoginInfo(data: responseString!)
                        self.getLoginInfo()
                        taskCallback(false, responseString)
                    }
                    return;
                    
                }
                else {
                    print("No data got from Url!")
                }
            }
            else {
                print("Error httpstatus code is: \(httpStatus!.statusCode)")
                if (httpStatus!.statusCode == 500) {
                    self.alert(viewController: viewController, message: "Oops! The system is being upgraded, please come back later.")
                }
                if data!.count != 0 {
                    let responseString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    DispatchQueue.main.async(){
                        taskCallback(true, responseString)
                        
                    }
                    return;
                }
                
            }
            DispatchQueue.main.async(){
                taskCallback(true, nil);
            }
            return;
            
        }
        task.resume()
    }
    
}
