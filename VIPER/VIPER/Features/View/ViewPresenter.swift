//
//  ViewPresenter.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import Foundation

protocol ViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapButton()
}

class ViewPresenter: ViewPresenterProtocol {
    weak var view: ViewProtocol?
    var interactor: ViewInteractorProtocol?
    var router: ViewRouterProtocol?

    func viewDidLoad() {
        
    }

    func didTapButton() {
        router?.showAlert()
    }
}
