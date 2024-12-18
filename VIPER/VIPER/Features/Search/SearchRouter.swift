//
//  SearchRouter.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
}

final class SearchRouter: SearchRouterProtocol {

    private weak var view: SearchViewProtocol!

    static func build() -> SearchView {
        let view = SearchView()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()

        router.view = view
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router

        return view
    }
}
