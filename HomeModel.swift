//
//  HomeModel.swift
//  Como App
//
//  Created by Ankit Goel on 02/05/18.
//

import UIKit

class HomeModel: NSObject {
    
    var task_id : String!
    var task_title : String!
    var task_description : String!
    var task_credit : String!
    var task_end_date : String!
    var created_at : String!
    var task_visibility : String!
    var user_id : String!
    var full_name : String!
    var profile_pic_image : String!
    var location_address : String!
    var category_name : String!
    var location_country : String!
    var location_city : String!
    var location_state : String!
    
    init(task_id : String,task_title : String,task_description : String,task_credit : String,task_end_date : String,created_at : String,task_visibility : String,user_id : String,full_name : String,profile_pic_image : String,location_address : String,category_name : String, location_country : String, location_city : String, location_state: String) {
        
        self.task_id = task_id
        self.task_title = task_title
        self.task_description = task_description
        self.task_credit = task_credit
        self.task_end_date = task_end_date
        self.created_at = created_at
        self.task_visibility = task_visibility
        self.user_id = user_id
        self.full_name = full_name
        self.profile_pic_image = profile_pic_image
        self.location_address = location_address
        self.category_name = category_name
        self.location_country = location_country
        self.location_city = location_city
        self.location_state = location_state
        
    }
    
}
