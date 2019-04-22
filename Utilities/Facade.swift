//
//  Facade.swift
//  Rozie
//
//  Created by Ankit Goel on 30/01/18.
//

import UIKit
import RMessage

class Facade: NSObject {
    
    typealias completionBlock = (_ isSuccess : Bool) -> Void
    typealias completionBlockReseller = (_ json : Dictionary<String,Any>?) -> Void
    
    static func showError()
    {
        
        RMessage.showNotification(withTitle: "Error!", subtitle: "Please try again later", type: .error, customTypeName: "", callback: nil)
        
    }
    
    static func showWarning(msg : String)
    {
        RMessage.showNotification(withTitle: "", subtitle: msg, type: .warning,customTypeName: "", callback: nil)
        
        if msg == "Please provide valid key"
        {
            let navig : UINavigationController = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController
            
            UserDefaults.standard.setValue(false, forKey: "login")
            navig.popToRootViewController(animated: true)
        }
    }
    
    static func showSuccess(msg : String)
    {
        RMessage.showNotification(withTitle: "", subtitle: msg, type: .success,customTypeName: "", callback: nil)
    }
    

}
