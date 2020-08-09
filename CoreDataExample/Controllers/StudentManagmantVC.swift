//
//  StudentManagmantVC.swift
//  CoreDataExample
//
//  Created by Abdullah Ayyad on 7/16/20.
//  Copyright © 2020 Login. All rights reserved.
//
 


import UIKit
import CoreData
class StudentManagmantVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var studentTV:UITableView!
    @IBOutlet weak var nameTF :UITextField!
    @IBOutlet weak var avgTF :UITextField!
    @IBOutlet weak var imageView :UIImageView!

    
    var image1 = UIImage(named: "ItunesArtwork")
  
    var students = [Student](){
        didSet{
            studentTV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStudentTV()
        imageView.image = image1
    }
    
    var imagePicker = UIImagePickerController()
    @IBAction func btnClicked() {

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in

        })

        imageView.image = image
    }
    
    
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        getAllStudent()
    }
    
    
    func addStudent(name:String ,avg:Double){
    
        let data =  image1!.jpegData(compressionQuality: 0.3)

     let student = Student(context: context)
        student.name = name
        student.avg = avg
        student.image = data
        context.insert(student)
        appDelegate.saveContext()
        
        getAllStudent()
    }
    
    
    
    
    
    
    @IBAction func addStudentAction(_ sender:Any){
        
        if !nameTF.text!.isEmpty && !avgTF.text!.isEmpty {
            addStudent(name: nameTF.text!, avg: Double(avgTF.text!)!)
            
            nameTF.text = ""
            avgTF.text = ""
        }
    }
    
    
    
    
    func getAllStudent(){
        let request :NSFetchRequest<Student> = Student.fetchRequest()
        do{
            students = try context.fetch(request)
            
        }catch let error {
            print("Failed to fetch :\(error.localizedDescription)")
        }
    }

}
















extension StudentManagmantVC: UITableViewDataSource ,UITableViewDelegate {
    
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
        cell.imageView?.image = UIImage(data: student.image ?? Data())
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        let vc :EditStudentVC = self.storyboard!.instantiateViewController(identifier: "EditStudentVC")
        vc.student = student
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
