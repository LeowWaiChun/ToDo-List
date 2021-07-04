//
//  addTaskVC.swift
//  ToDo
//
//  Created by snoopy on 04/07/2021.
//

import UIKit

class addTaskVC: UIViewController {

    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var datePicker : UIDatePicker!
    
    var update : (() -> Void)?
    
    @objc func saveTask(){
        
        guard let text = titleField.text, !text.isEmpty else {return}
        
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = "dd MMMM yyyy-HH:MM"
        
        let pCount = UserDefaults.standard.integer(forKey: "pendingCount")
        
        let newTask : task = task(date: dateFormat.string(from: datePicker.date), title: text  , status: false)
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(newTask), forKey:"task\(0)\(pCount)")
        
        UserDefaults.standard.setValue(pCount+1, forKey: "pendingCount")
        
        update?()
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.layer.borderWidth = 1
        
        saveButton.layer.cornerRadius = 5
        
        titleField.becomeFirstResponder()
        
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
    }
}
