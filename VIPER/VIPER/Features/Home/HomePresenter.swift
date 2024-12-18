//
//  HomePresenter.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//


import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?

    func viewDidLoad() {

    }
}
