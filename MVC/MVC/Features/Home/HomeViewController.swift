//
//  HomeViewController.swift
//  MVC
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit

final class HomeViewController: UIViewController {

    init() {
        super.init(nibName: "HomeView", bundle: .main)
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
