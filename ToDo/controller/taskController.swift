//
//  taskController.swift
//  ToDo
//
//  Created by snoopy on 04/07/2021.
//

import UIKit

class taskController: UIViewController , UITableViewDelegate {

    var tasks = [[task](),[task]()]
    
    @IBOutlet weak var toDoTable : UITableView!
    @IBAction func addTask(){
        
        guard let addVc = navigationController?.storyboard?.instantiateViewController(identifier: "add_vc") as? addTaskVC else {return}
        
        present(addVc, animated: true)
        
        addVc.update = {
            DispatchQueue.main.async {
                guard let text = addVc.titleField.text, !text.isEmpty else {return}
                self.updateTask()
            }
        }
    }
    
    func updateTask(){
        
        self.tasks.removeAll()
        
        tasks = [[] , []]
        
        let allTaskCount : [Int] = [UserDefaults.standard.integer(forKey: "pendingCount") , UserDefaults.standard.integer(forKey: "completeCount")]
        
        for section in 0..<allTaskCount.count{
            
            for row in 0..<allTaskCount[section]{
                
                guard let data = UserDefaults.standard.value(forKey: "task\(section)\(row)") as? Data else {return}
                
                let tempTask = try? PropertyListDecoder().decode(task.self, from: data)
                
                tasks[section].append(task(date: tempTask!.date, title: tempTask!.title, status: tempTask!.status))
            }
        }
        toDoTable.reloadData()
    }
    
    func updateEmptyTask(section : Int , row : Int , delete : Bool){
        
        var oldSection = 0 , deleteRow = row;
        
        oldSection = section
        
        let keyCount = (section == 0) ? UserDefaults.standard.integer(forKey: "pendingCount") : UserDefaults.standard.integer(forKey: "completeCount")
        
        if(delete){
            section == 0 ? UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey:"pendingCount")-1, forKey: "pendingCount") : UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey:"completeCount")-1, forKey: "completeCount")
        }
        
        while(deleteRow<keyCount){
            
            guard let data = UserDefaults.standard.value(forKey: "task\(oldSection)\(deleteRow+1)") as? Data else {return}
            
            let tempTask = try? PropertyListDecoder().decode(task.self, from: data)
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(tempTask), forKey:"task\(oldSection)\(deleteRow)")
            
            deleteRow += 1
        }
    }
    
    func updateTaskStatus(oldRow : Int , oldSection : Int , newSection : Int  , newRow : Int){
        
        !tasks[oldSection][oldRow].status ? tasks[newSection].append(task(date: tasks[oldSection][oldRow].date, title: tasks[oldSection][oldRow].title, status: true)) :tasks[newSection].append(task(date: tasks[oldSection][oldRow].date, title: tasks[oldSection][oldRow].title, status: false))

        UserDefaults.standard.removeObject(forKey: "task\(oldSection)\(oldRow)")
        
        updateEmptyTask(section : oldSection , row : oldRow , delete: false)
        
        if(!tasks[oldSection][oldRow].status){
            UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey:"pendingCount")-1, forKey: "pendingCount")
            UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey:"completeCount")+1, forKey: "completeCount")
        }
        else{
            UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey:"pendingCount")+1, forKey: "pendingCount")
            UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey:"completeCount")-1, forKey: "completeCount")
        }
        tasks[oldSection].remove(at: oldRow)
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(tasks[newSection][newRow]), forKey:"task\(newSection)\(newRow)")
        
        updateTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTask()
        
    }
}
extension taskController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Pending" : "Completed"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! taskListCell
        
        let task = tasks[indexPath.section][indexPath.row]
        
        cell.displayData(displayTask: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSection = (indexPath.section==0) ? 1 : 0
        
        updateTaskStatus(oldRow: indexPath.row ,oldSection : indexPath.section , newSection: newSection ,newRow:tasks[newSection].count)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.tasks[indexPath.section].remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)

        UserDefaults.standard.removeObject(forKey: "task\(indexPath.section)\(indexPath.row)")

        updateEmptyTask(section: indexPath.section, row: indexPath.row , delete : true)
        
        updateTask()
    }
}
