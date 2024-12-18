//
//  SearchViewController.swift
//  MVC
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit

final class SearchViewController: UIViewController {

    init() {
        super.init(nibName: "SearchView", bundle: .main)
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
