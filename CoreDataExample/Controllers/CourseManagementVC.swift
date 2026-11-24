//
//  CourseManagementVC.swift
//  CoreDataExample
//

import CoreData
import UIKit

final class CourseManagementVC: UIViewController {

    @IBOutlet private weak var courseTV: UITableView!
    @IBOutlet private weak var nameTF: UITextField!

    private var courses = [Course]() {
        didSet { courseTV.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        courseTV.dataSource = self
        courseTV.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCourses()
    }

    // MARK: - Actions

    @IBAction private func addCourseAction(_ sender: Any) {
        let name = nameTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "Missing name", message: "Enter a course name.")
            return
        }

        let course = Course(context: context)
        course.name = name
        appDelegate.saveContext()

        nameTF.text = ""
        loadCourses()
    }

    // MARK: - Data

    private func loadCourses() {
        let request: NSFetchRequest<Course> = Course.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            courses = try context.fetch(request)
        } catch {
            showAlert(title: "Could not load courses", message: error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CourseManagementVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = courses[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard else { return }
        let editor: EditCourseVC = storyboard.instantiateViewController(identifier: "EditCourseVC")
        editor.course = courses[indexPath.row]
        navigationController?.pushViewController(editor, animated: true)
    }
}
