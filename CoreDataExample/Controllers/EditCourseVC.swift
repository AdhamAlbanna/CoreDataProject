//
//  EditCourseVC.swift
//  CoreDataExample
//

import UIKit

final class EditCourseVC: UIViewController {

    @IBOutlet private weak var studentTV: UITableView!
    @IBOutlet private weak var nameTF: UITextField!

    var course: Course!

    private var students: [Student] {
        let enrolled = course.takenBy?.allObjects as? [Student] ?? []
        return enrolled.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = course.name
        studentTV.dataSource = self
        studentTV.delegate = self
    }

    // MARK: - Actions

    @IBAction private func saveCourseAction(_ sender: Any) {
        let name = nameTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "Missing name", message: "Enter a course name.")
            return
        }

        course.name = name
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EditCourseVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let student = students[indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = String(student.avg)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard else { return }
        let editor: EditStudentVC = storyboard.instantiateViewController(identifier: "EditStudentVC")
        editor.student = students[indexPath.row]
        navigationController?.pushViewController(editor, animated: true)
    }
}
