//
//  tas.swift
//  ToDo
//
//  Created by snoopy on 04/07/2021.
//

import Foundation

struct task : Codable{
    
    var date : String
    var title : String
    var status : Bool
    
    init(date : String , title : String , status : Bool){
        
        self.date = date
        
        self.title = title
        
        self.status = status
        
    }
}
