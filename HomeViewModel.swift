//
//  HomeViewModel.swift
//  Como App
//
//  Created by Ankit Goel on 02/05/18.
//

import UIKit

class HomeViewModel: NSObject {
    
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
    var model : HomeModel
    
    init(model : HomeModel) {
        
        self.model = model
        self.task_id = model.task_id
        self.task_title = model.task_title
        self.task_description = model.task_description
        self.task_credit = model.task_credit
        self.task_end_date = model.task_end_date
        self.created_at = model.created_at
        self.task_visibility = model.task_visibility
        self.user_id = model.user_id
        self.full_name = model.full_name
        self.profile_pic_image = model.profile_pic_image
        self.location_address = model.location_address
        self.category_name = model.category_name
        self.location_country = model.location_country
        self.location_city = model.location_city
        self.location_state = model.location_state
        
    }
}
