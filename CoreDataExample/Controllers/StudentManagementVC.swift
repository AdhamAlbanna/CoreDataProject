//
//  StudentManagementVC.swift
//  CoreDataExample
//

import CoreData
import UIKit

final class StudentManagementVC: UIViewController {

    @IBOutlet private weak var studentTV: UITableView!
    @IBOutlet private weak var nameTF: UITextField!
    @IBOutlet private weak var avgTF: UITextField!
    @IBOutlet private weak var imageView: UIImageView!

    private let placeholderImage = UIImage(systemName: "person.crop.circle.fill")
    private var selectedImage: UIImage?
    private let imagePicker = UIImagePickerController()

    private var students = [Student]() {
        didSet { studentTV.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        studentTV.dataSource = self
        studentTV.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imageView.image = placeholderImage
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudents()
    }

    // MARK: - Actions

    @IBAction private func btnClicked() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(title: "Unavailable", message: "The photo library is not available on this device.")
            return
        }
        present(imagePicker, animated: true)
    }

    @IBAction private func addStudentAction(_ sender: Any) {
        let name = nameTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "Missing name", message: "Enter the student's name.")
            return
        }
        guard let text = avgTF.text, let average = Double(text) else {
            showAlert(title: "Invalid average", message: "Enter the average as a number, for example 85.5.")
            return
        }

        let student = Student(context: context)
        student.name = name
        student.avg = average
        student.image = selectedImage?.jpegData(compressionQuality: 0.3)
        appDelegate.saveContext()

        nameTF.text = ""
        avgTF.text = ""
        selectedImage = nil
        imageView.image = placeholderImage
        loadStudents()
    }

    // MARK: - Data

    private func loadStudents() {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            students = try context.fetch(request)
        } catch {
            showAlert(title: "Could not load students", message: error.localizedDescription)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension StudentManagementVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StudentManagementVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let student = students[indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = String(student.avg)
        cell.imageView?.image = student.image.flatMap { UIImage(data: $0) }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard else { return }
        let editor: EditStudentVC = storyboard.instantiateViewController(identifier: "EditStudentVC")
        editor.student = students[indexPath.row]
        navigationController?.pushViewController(editor, animated: true)
    }
}
