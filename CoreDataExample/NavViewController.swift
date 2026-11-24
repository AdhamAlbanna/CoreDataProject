//
//  NavViewController.swift
//  CoreDataExample
//

import UIKit

final class NavViewController: UINavigationController {

    var isDark = false {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        isDark ? .lightContent : .default
    }

    func toggleAppearance() {
        isDark.toggle()
    }
}
