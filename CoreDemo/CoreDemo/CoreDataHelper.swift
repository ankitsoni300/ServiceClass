//
//  CoreDataHelper.swift
//  CoreDemo
//
//  Created by Ankit Soni on 10/04/19.
//  Copyright © 2019 Ankit Soni. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper{
    
    static let shared = CoreDataHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Save Data
    func save(object : [String : String]) {
        
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student
        
        student.name = object["name"]
        student.city = object["city"]
        student.mobile = object["mobile"]
        student.address = object["address"]
        
        do{
            try context.save()
        }
        catch{
            print("Data not saved")
        }
    }
    
    //Get Data
    func getData() -> [Student]{
        
        var student = [Student]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        
        do{
            try student = context.fetch(fetchRequest) as! [Student]
        }catch{
            print("Not able to fetch data")
        }
        
        return student
        
    }
    
    //Delete Data
    
    func delete(index : Int) -> [Student] {
        var student = getData()
        context.delete(student[index])
        student.remove(at: index)
        do{
            try context.save()
        }
        catch{
            print("Can't delete")
        }
        return student
    }
    
    //Update Data
    
    func update(object : [String : String], i : Int) -> [Student] {
        let student = getData()
        student[i].name = object["name"]
        student[i].address = object["address"]
        student[i].city = object["city"]
        student[i].mobile = object["mobile"]
        do{
            try context.save()
        }catch{
            print("Can't update")
        }
        return student
    }
    
}
