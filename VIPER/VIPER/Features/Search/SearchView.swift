//
//  SearchView.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit

protocol SearchViewProtocol: UIViewController {

}

final class SearchView: UIViewController, SearchViewProtocol {

    var presenter: SearchPresenterProtocol?

    init() {
        super.init(nibName: "SearchView", bundle: .main)
        self.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}
