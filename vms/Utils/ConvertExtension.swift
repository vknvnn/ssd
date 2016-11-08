//
//  ConvertExtension.swift
//  vms
//
//  Created by NghiepVo on 11/7/16.
//  Copyright © 2016 360vms. All rights reserved.
//

import Foundation

extension String {
    func toDateTimeLogin() -> NSDate?
    {
        let str = self.replacingOccurrences(of: " GMT", with: "")        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let dateFromString :NSDate? = dateFormatter.date(from: str) as NSDate?
        return dateFromString;
    }
    
    func toInt() -> Int?
    {
        let result = Int(self)
        return result;
    }
}
