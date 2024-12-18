//
//  HomeRouter.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//


import UIKit

protocol HomeRouterProtocol: AnyObject {
}

final class HomeRouter: HomeRouterProtocol {

    private weak var view: HomeViewProtocol!

    static func build() -> HomeView {
        let view = HomeView()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()

        router.view = view
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router

        return view
    }
}
