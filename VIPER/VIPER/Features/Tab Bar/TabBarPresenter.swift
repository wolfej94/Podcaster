//
//  TabbarViewPresenter.swift
//
//
//  Created by James Wolfe on 04/12/2024.
//

import Foundation

protocol TabBarViewPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class TabBarViewPresenter: TabBarViewPresenterProtocol {
    weak var view: TabBarViewProtocol?
    var router: TabBarRouterProtocol?

    func viewDidLoad() {
        
    }
}
