//
//  UIViewController+Extention.swift
//  CoreDataExample
//
//  Created by Abdullah Ayyad on 7/16/20.
//  Copyright © 2020 Login. All rights reserved.
//

import Foundation
import UIKit
import CoreData
extension UIViewController {
    
    var appDelegate :AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    
    var context :NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
