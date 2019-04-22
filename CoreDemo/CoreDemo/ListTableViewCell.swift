//
//  ListTableViewCell.swift
//  CoreDemo
//
//  Created by Ankit Soni on 10/04/19.
//  Copyright © 2019 Ankit Soni. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    var student : Student!{
        didSet{
            lblMobile.text = student.mobile
            lblName.text = student.name
            lblAddress.text = student.address
            lblCity.text = student.city
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
