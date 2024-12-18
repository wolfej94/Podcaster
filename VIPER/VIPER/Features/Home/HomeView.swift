//
//  HomeView.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit

protocol HomeViewProtocol: UIViewController {

}

final class HomeView: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol?

    init() {
        super.init(nibName: "HomeView", bundle: .main)
        self.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}
