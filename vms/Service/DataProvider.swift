//
//  DataProvider.swift
//  vms
//
//  Created by NghiepVo on 11/5/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import Foundation
import UIKit

struct Oauth2Struct {
    static let expires = ".expires"
    static let issued = ".issued"
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
    static let timeZoneOffset = "time_zone_offset"
    static let tenantid = "tenantid"
}

class DataProvider {
    
    let _urlApi :String = "https://dev-api.360vms.com/"
    //let _urlApi :String = "http://192.168.1.66/"
    let _clientId: String = "iOSApp"
    let _clientSecret: String = "iOSApp_360Vms"
    let _loading = LoadingViewController()
    var _expires:NSDate? = nil
    var _issued:NSDate? = nil
    var _accessToken:String? = nil;
    var _refreshToken:String? = nil;
    var _timeZoneOffset:Int? = nil;
    var _tenantId:String? = nil;
    
    init() {
        getLoginInfo();
    }
    
    func alert(viewController: UIViewController, message: String, okCallback: (() -> Swift.Void)? = nil, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            if okCallback != nil {
                okCallback!()
            }
        })
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func getTimeZone() -> Int {
        var secondsFromGMT: Int { return NSTimeZone.local.secondsFromGMT() }
        return secondsFromGMT / 60
    }
    
    func saveLoginInfo(data: NSDictionary) {
        let defaults = UserDefaults.standard;
        defaults.setValue(data[Oauth2Struct.expires], forKey: Oauth2Struct.expires)
        defaults.setValue(data[Oauth2Struct.issued], forKey: Oauth2Struct.issued)
        defaults.setValue(data[Oauth2Struct.accessToken], forKey: Oauth2Struct.accessToken)
        defaults.setValue(data[Oauth2Struct.refreshToken], forKey: Oauth2Struct.refreshToken)
        defaults.setValue(data[Oauth2Struct.timeZoneOffset], forKey: Oauth2Struct.timeZoneOffset)
        defaults.setValue(data[Oauth2Struct.tenantid], forKey: Oauth2Struct.tenantid)
        defaults.synchronize()
    }
    
    func clearLoginInfo() {
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: Oauth2Struct.expires)
        defaults.removeObject(forKey: Oauth2Struct.issued)
        defaults.removeObject(forKey: Oauth2Struct.accessToken)
        defaults.removeObject(forKey: Oauth2Struct.refreshToken)
        defaults.removeObject(forKey: Oauth2Struct.timeZoneOffset)
        defaults.removeObject(forKey: Oauth2Struct.tenantid)
        defaults.synchronize()
    }
    func getLoginInfo() {
        let defaults = UserDefaults.standard;
        var strValue:String? = nil;
        strValue = defaults.string(forKey: Oauth2Struct.expires)
        if strValue != nil {
            _expires = strValue!.toDateTimeLogin();
        }
        else {
            return;
        }
        strValue = defaults.string(forKey: Oauth2Struct.issued)
        if strValue != nil {
            _issued = strValue!.toDateTimeLogin();
        }
        _accessToken = defaults.string(forKey: Oauth2Struct.accessToken)
        _refreshToken = defaults.string(forKey: Oauth2Struct.refreshToken)
        
        strValue = defaults.string(forKey: Oauth2Struct.timeZoneOffset)
        if strValue != nil {
            _timeZoneOffset = strValue!.toInt();
        }
        _tenantId = defaults.string(forKey: Oauth2Struct.tenantid)
    }
}
