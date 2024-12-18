//
//  SearchPresenter.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?

    func viewDidLoad() {

    }
}
