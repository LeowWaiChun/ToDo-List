//
//  taskListCell.swift
//  ToDo
//
//  Created by snoopy on 04/07/2021.
//

import UIKit

class taskListCell: UITableViewCell {
    
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var statusImage : UIImageView!
    
    func displayData(displayTask : task){
        
        date.text = displayTask.date
        
        title.text = displayTask.title
        
        let displayImage = (displayTask.status) ? "check" : "pending"
        
        statusImage.image = UIImage(named: displayImage)
    }
}
