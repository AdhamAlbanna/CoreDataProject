//
//  EditStudentVC.swift
//  CoreDataExample
//
//  Created by Abdullah Ayyad on 7/16/20.
//  Copyright © 2020 Login. All rights reserved.
//

import UIKit

class EditCourseVC: UIViewController {
    
    @IBOutlet weak var studentTV :UITableView!
    @IBOutlet weak var nameTF :UITextField!
    
    var course:Course!
    
    
    var students :[Student] {
        get{
            return self.course.takenBy!.allObjects as! [Student]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = course.name
        
        initStudentTV()
        // Do any additional setup after loading the view.
    }
    
    
    func editCourse(name:String){
        course.name = name
        appDelegate.saveContext()
    }
    
    
    
    @IBAction func saveCourseAction(_ sender:Any){
        
        if !nameTF.text!.isEmpty  {
            editCourse(name: nameTF.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}







extension EditCourseVC: UITableViewDataSource ,UITableViewDelegate {
    
    func initStudentTV(){
        studentTV.dataSource = self
        studentTV.delegate = self
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let student = students[indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = String(student.avg)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        let vc :EditStudentVC = self.storyboard!.instantiateViewController(identifier: "EditStudentVC")
        vc.student = student
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


