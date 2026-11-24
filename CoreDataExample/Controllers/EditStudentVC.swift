//
//  EditStudentVC.swift
//  CoreDataExample
//

import CoreData
import UIKit

final class EditStudentVC: UIViewController {

    @IBOutlet private weak var courseTV: UITableView!
    @IBOutlet private weak var nameTF: UITextField!
    @IBOutlet private weak var avgTF: UITextField!

    var student: Student!

    private var allCourses = [Course]()

    private var enrolledCourses: Set<Course> {
        (student.enroll as? Set<Course>) ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = student.name
        avgTF.text = String(student.avg)
        courseTV.dataSource = self
        courseTV.delegate = self
        loadCourses()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Leaving without tapping Save discards the unsaved edits.
        if context.hasChanges { context.rollback() }
    }

    // MARK: - Actions

    @IBAction private func saveStudentAction(_ sender: Any) {
        let name = nameTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "Missing name", message: "Enter the student's name.")
            return
        }
        guard let text = avgTF.text, let average = Double(text) else {
            showAlert(title: "Invalid average", message: "Enter the average as a number, for example 85.5.")
            return
        }

        student.name = name
        student.avg = average
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Data

    private func loadCourses() {
        let request: NSFetchRequest<Course> = Course.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            allCourses = try context.fetch(request)
        } catch {
            showAlert(title: "Could not load courses", message: error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EditStudentVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCourses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let course = allCourses[indexPath.row]
        cell.textLabel?.text = course.name
        cell.accessoryType = enrolledCourses.contains(course) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = allCourses[indexPath.row]

        if enrolledCourses.contains(course) {
            student.removeFromEnroll(course)
        } else {
            student.addToEnroll(course)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
