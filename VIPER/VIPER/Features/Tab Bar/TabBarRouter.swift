//
//  TabBarRouter.swift
//
//
//  Created by James Wolfe on 04/12/2024.
//

import UIKit

protocol TabBarRouterProtocol: AnyObject {
    func presentTabs()
}

final class TabBarRouter: TabBarRouterProtocol {

    private weak var view: TabBarViewProtocol!

    static func build() -> TabBarView {
        let view = TabBarView()
        let presenter = TabBarViewPresenter()
        let router = TabBarRouter()

        router.view = view
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.presentTabs()

        return view
    }

    func presentTabs() {
        let homeView = HomeRouter.build()
        let searchView = SearchRouter.build()
        view.setupTabs(homeView: homeView, searchView: searchView)
    }
}
