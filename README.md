# CoreDataProject

A small iOS app in **Swift** that manages **students and courses** and stores everything locally with **Core Data**. It is a practical example of the full create / read / update / delete cycle and of a relationship between two entities.

## Features
- Add, edit and delete students, with a photo for each student from the photo library
- Add, edit and delete courses
- Assign courses to students
- Data is persisted on the device, with no backend needed

## Tech
- Swift, UIKit, Storyboards
- Core Data (`Student` and `Course` entities, `NSFetchRequest`)
- `UIImagePickerController`
- Small `UIViewController` and `UIStoryboard` extensions to keep screens clean

## Project structure
```
CoreDataExample/
  Controllers/    Student and course screens
  Extention/      Helpers (Core Data context, storyboard loading)
  CoreDataExample.xcdatamodeld   Data model
```

## Run it
1. Clone the repository
2. Open `CoreDataExample.xcodeproj` in Xcode
3. Choose a simulator or device and press **Run**

## Author
Adham Albanna · [LinkedIn](https://www.linkedin.com/in/adhamalbanna/)
