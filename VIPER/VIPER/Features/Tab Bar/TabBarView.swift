//
//  TabBarView.swift
//  VIPER
//
//  Created by James Wolfe on 04/12/2024.
//

import UIKit

protocol TabBarViewProtocol: UITabBarController {
    func setupTabs(homeView: HomeViewProtocol, searchView: SearchViewProtocol)
}

final class TabBarView: UITabBarController, TabBarViewProtocol {
    var presenter: TabBarViewPresenterProtocol?

    init() {
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    func setupTabs(homeView: HomeViewProtocol, searchView: SearchViewProtocol) {
        setViewControllers([homeView, searchView], animated: false)
    }

}
