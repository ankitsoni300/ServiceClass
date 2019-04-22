//
//  SingletonClass.swift
//  Rozie
//
//  Created by Kirti Rai on 08/02/18.
//

import UIKit

class SingletonClass: NSObject {

    static var sharedMySigleton = SingletonClass()
    
    var latitude = Double()
    var longitude = Double()
    var arrRecentSearch : Array = [String]()
    var storeFilterData : Dictionary = [String : Any]()
    var isComeToHome = Bool()
    class func sharedInstance() -> SingletonClass {
        return self.sharedMySigleton
    }
    
    override init() {
        print(#function)
    }
    
}
