//
//  EditStudentVC.swift
//  CoreDataExample
//
//  Created by Abdullah Ayyad on 7/16/20.
//  Copyright © 2020 Login. All rights reserved.
//

import UIKit
import CoreData
class EditStudentVC: UIViewController {
    
    @IBOutlet weak var courseTV :UITableView!

    @IBOutlet weak var nameTF :UITextField!
    @IBOutlet weak var avgTF :UITextField!
    
    var student:Student!
    
    var allCourses :[Course] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = student.name
        avgTF.text = student.avg.description
        
        
        print(student.enroll?.count as Any)
        
        initCourseTV()
        getAllCourse()
         // Do any additional setup after loading the view.
    }
    
    
    func editStudent(name:String ,avg:Double){
        student.name = name
        student.avg = avg
        appDelegate.saveContext()
    }
    
    
    
    @IBAction func saveStudentAction(_ sender:Any){
        
        if !nameTF.text!.isEmpty && !avgTF.text!.isEmpty {
            editStudent(name: nameTF.text!, avg: Double(avgTF.text!)!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}






extension EditStudentVC: UITableViewDataSource ,UITableViewDelegate {
    
    
      func getAllCourse(){
          let request :NSFetchRequest<Course> = Course.fetchRequest()
          do{
              allCourses = try context.fetch(request)
              
          }catch let error {
              print("Failed to fetch :\(error.localizedDescription)")
          }
      }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        context.reset()
    }
    
    
    func initCourseTV(){
        courseTV.dataSource = self
        courseTV.delegate = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        let course = allCourses[indexPath.row]
        cell.textLabel?.text = course.name
        
        let ownCourses = student.enroll?.allObjects as! [Course]
         
        for ownCours in ownCourses {
            if course == ownCours {
                cell.accessoryType = .checkmark
                break
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course  = allCourses[indexPath.row]
        
        let cell = courseTV.cellForRow(at: indexPath)
        
        if  cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            student.removeFromEnroll(course)
        }else{
            cell?.accessoryType = .checkmark
            student.addToEnroll(course)

        }
        
    }
    
}
