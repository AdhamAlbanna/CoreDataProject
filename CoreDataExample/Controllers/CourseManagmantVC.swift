//
//  StudentManagmantVC.swift
//  CoreDataExample
//
//  Created by Abdullah Ayyad on 7/16/20.
//  Copyright © 2020 Login. All rights reserved.
///
 //


import UIKit
import CoreData
class CourseManagmantVC: UIViewController {
    
    
    @IBOutlet weak var courseTV:UITableView!
    @IBOutlet weak var nameTF :UITextField!

  
    var courses = [Course](){
        didSet{
            courseTV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCourseTV()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllCourse()
    }
    
    
    func addCourse(name:String ){
     let course = Course(context: context)
        course.name = name
        
        context.insert(course)
        appDelegate.saveContext()
        
        getAllCourse()
    }
    
    @IBAction func addCourseAction(_ sender:Any){
        
        if !nameTF.text!.isEmpty {
            addCourse(name: nameTF.text!)
            nameTF.text = ""
        }
    }
    
    
    
    
    func getAllCourse(){
        let request :NSFetchRequest<Course> = Course.fetchRequest()
        do{
            courses = try context.fetch(request)
            
        }catch let error {
            print("Failed to fetch :\(error.localizedDescription)")
        }
    }

}











extension CourseManagmantVC: UITableViewDataSource ,UITableViewDelegate {
    
    func initCourseTV(){
        courseTV.dataSource = self
        courseTV.delegate = self
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        let student = courses[indexPath.row]
        cell.textLabel?.text = student.name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        let vc :EditCourseVC = self.storyboard!.instantiateViewController(identifier: "EditCourseVC")
        vc.course = course
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
