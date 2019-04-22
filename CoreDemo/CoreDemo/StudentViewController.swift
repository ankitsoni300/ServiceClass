//
//  StudentViewController.swift
//  CoreDemo
//
//  Created by Ankit Soni on 10/04/19.
//  Copyright © 2019 Ankit Soni. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, DataPass {
   
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    
    var isUpdate = Bool()
    var i = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        let dict = ["name":name.text,"address":address.text,"city":city.text,"mobile":mobile.text]
        
        if isUpdate{
            CoreDataHelper.shared.update(object: dict as! [String : String], i: i)
        }else{
            CoreDataHelper.shared.save(object: dict as! [String : String])
        }
        
        
    }
    @IBAction func btnShow(_ sender: UIButton) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") as? ListTableViewController {
            
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
    }
    
    func sendData(dictData: [String : String], index: Int, isEdit: Bool) {
        name.text = dictData["name"]
        mobile.text = dictData["mobile"]
        address.text = dictData["address"]
        city.text = dictData["city"]
        
        isUpdate = isEdit
        i = index
    }
    
}
