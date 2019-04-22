//
//  AppHelper.swift
//  Como App
//
//  Created by Ankit Goel on 23/04/18.
//

import UIKit

class AppHelper: NSObject {
    
    // Save Local Data
    class func save(value: String,key: String) {
        
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        
    }
    
    class func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM"
        return  dateFormatter.string(from: date!)
        
    }
    class func getTimeStatus_MDY(strTempDate : String)->String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: strTempDate)
        dateFormatter.timeZone = TimeZone.current
        // dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    class func getDateFormate_MDY(strTempDate : String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: strTempDate)
        formatter.dateFormat = "dd MMM"
        let strNewDate = formatter.string(from: date!)
        print("date == \(strNewDate)")
        return strNewDate
    }
    
    class func getTransition() -> CATransition
    {
        let transition:CATransition = CATransition()
    
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        return transition
    }
    
}
