//
//  Constant.swift
//  Scholiber
//  Created by on 09/10/17.
//  Copyright © 2017  All rights reserved.
//

import UIKit

class CommanUtil: NSObject
{
    /*---- For to stor the side menu index------*/
    
    
    /*------ Validate Email ID ------*/
    class func isValidEmail(emailString:String)-> Bool
    {
        
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    class func checkValidValue(dataDict : [String:Any],key: String)->Bool
    {
        if dataDict[key] != nil
        {
            if dataDict[key] is NSNull
            {
                return false
            }else
            {
                return true
            }
            
        }else
        {
            return false
        }
    }
    
    class func isValidPhone(phone: String) -> Bool {
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: phone, options: [], range: NSMakeRange(0, phone.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == phone.count
            } else {
                return false
            }
        } catch {
            return false
        }
        
    }
    /*------ Validate full name  ------*/
    class func isValidFullName(testStr:String) -> Bool
    {
        let fullNameRegEx = "^[a-zA-Z_ ]*$"
        let fullNameTest = NSPredicate(format:"SELF MATCHES %@", fullNameRegEx)
        return fullNameTest.evaluate(with: testStr)
    }
    
    
    // MARK:- For Trim a string
    class func trimString(string: NSString)-> String
    {
        let trimmedString = string.trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines
        )
        
        return trimmedString
    }
    
    static func textFieldBlankorNot(_ textfield: UITextField) -> Bool {
        let rawString: String = textfield.text!
        let whitespace = CharacterSet.whitespacesAndNewlines
        var trimmed = rawString.trimmingCharacters(in: whitespace)
        if (trimmed.characters.count ) == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    
    func isValidName(_ nameString: String) -> Bool {
        
        var returnValue = true
        let mobileRegEx =  "[A-Za-z]{3}"  // {3} -> at least 3 alphabet are compulsory.
        
        do {
            let regex = try NSRegularExpression(pattern: mobileRegEx)
            let nsString = nameString as NSString
            let results = regex.matches(in: nameString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    class func isValidUserName(testStr:String) -> Bool {
        let usernameRegEx = "^[0-9a-zA-Z\\_]{1,18}$"
        
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluate(with: testStr)
    }
    
    // MARK:- For blue back color
    class  func blueColor()->UIColor
    {
        return UIColor(red: 2.0/255.0, green: 157.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
    
    class  func headerColor()->UIColor
    {
        
        return UIColor(red: 72.0/255.0, green: 80.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    }
    
    class  func subHeadingColor()->UIColor
    {
        
        return UIColor(red: 182.0/255.0, green: 185.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    
    class  func bodyColor()->UIColor
    {
        
        return UIColor(red: 200.0/255.0, green: 202.0/255.0, blue: 208.0/255.0, alpha: 1.0)
    }
    
    class  func greenAppColor()->UIColor
    {
        
        return UIColor(red: 40.0/255.0, green: 183.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    }
    class  func grayAppColor()->UIColor
    {
        return UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    }
    
    /*------ Show alert view----- */
    class func showAlert(withTitle title: String, withMsg msg: String, in controller: UIViewController)
    {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    class func showAlertWithOutOk(withTitle title: String, withMsg msg: String, in controller: UIViewController)
    {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK:- For gray back color
    class  func getPurpleColor()->UIColor
    {
        
        return UIColor(red: 171/255.0, green: 85/255.0, blue: 191/255.0, alpha: 1.0)
    }
    
    class  func getbackgroundGrayColor()->UIColor
    {
        
        return UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    }
    
    class  func getRGB(redColor:Float,greenColor:Float,blueColor:Float)->UIColor
    {
        
        return UIColor(red: CGFloat(redColor/255.0), green: CGFloat(greenColor/255.0), blue: CGFloat(blueColor/255.0), alpha: 1.0)
    }
    
    // MARK:- For Light black color
    class  func lightGreenColor()->UIColor
    {
        
        return UIColor(red: 27.0/255.0, green: 176.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    }
    
    
    class  func lightBlackColor()->UIColor
    {
        
        return UIColor(red: 101/255.0, green: 101/255.0, blue: 101/255.0, alpha: 1.0)
    }
    
    class func saveDictionary(dict:[String:Any] , withKey key: String) {
        let defaults = UserDefaults.standard
        var data: NSData? = nil
        if !dict.isEmpty {
            data = NSKeyedArchiver.archivedData(withRootObject: dict) as NSData?
        }
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    class func isValidInput(Input:String) -> Bool {
        let RegEx = ".*[^A-Za-z0-9].*"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    class func DeletDictnory(key: String)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    class func getDictionaryForKey(key: String) -> [String : Any] {
        
        if let newData = UserDefaults.standard.object(forKey: key)
        {
            let loginDic = NSKeyedUnarchiver.unarchiveObject(with: (newData as! NSData) as Data )!
            return loginDic as! [String : Any]
            
        }else
        {
            return ["":""]
        }
        
        
        //        let defaults = UserDefaults.standard
        //        let data = defaults.object(forKey: key)!
        //        var userDict: [NSDictionary]? = nil
        //        if data != nil {
        //            userDict = NSKeyedUnarchiver.unarchiveObject(with:(data as! Data))! as! NSDictionary
        //        }
    }
    
    
    class func saveString(str: String, withKey key: String) {
        let defaults = UserDefaults.standard
        //var data: NSData? = nil
        if !str.isEmpty {
            //data = NSKeyedArchiver.archivedData(withRootObject: str) as NSData?
            defaults.set(str, forKey: key)
            
        }
        defaults.synchronize()
    }
    
    
    class func getStringForKey(key: String) -> String {
        
        let newData = UserDefaults.standard.object(forKey: key)
        
        if (newData != nil)
        {
            return newData as! String
        }else{
            return ""
        }
    }
    
    
    class func removeValue(key: String) {
        
        let newData = UserDefaults.standard
        newData.removeObject(forKey: key)
        
    }
    class func getValueFromDict(dict:[String:Any], key: String) -> String
    {
        if let value = dict[key]
        {
            if(String(format:"%@",value as! CVarArg) == "")
            {
                return "N/A"
                
            } else {
                return String(format:"%@",value as! CVarArg)
                
            }
            
            
        } else {
            return "N/A"
            
        }
        
    }
    
    class func removeHTMLTags(message: String) -> String {
        
        return message.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    class func alertSheet(title : String?, message : String?, in controller : UIViewController ){
        
        let actionSheet = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheet.view.tintColor = UIColor.darkGray  // change text color of the buttons
        
        actionSheet.view.layer.cornerRadius = 25
        let actionReportPost = UIAlertAction(title: "Report this post", style: .default, handler: nil)
        let actionHideThisPost = UIAlertAction(title: "Hide this post", style: .default, handler: nil)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        cancel.setValue(UIColor.init(red: 255/255, green: 77/255, blue: 225/255, alpha: 1), forKey: "titleTextColor")
        
        actionSheet.addAction(actionReportPost)
        actionSheet.addAction(actionHideThisPost)
        actionSheet.addAction(cancel)
        
        controller.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //DateConvertor
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
}
