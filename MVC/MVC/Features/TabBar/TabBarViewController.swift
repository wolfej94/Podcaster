//
//  TabBarViewController.swift
//  MVC
//
//  Created by James Wolfe on 04/12/2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: .main)
        setViewControllers([HomeViewController(), SearchViewController()], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

