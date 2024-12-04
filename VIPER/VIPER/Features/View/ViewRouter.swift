//
//  ViewRouter.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import UIKit

protocol ViewRouterProtocol: AnyObject {
    // Define navigation methods
}

class ViewRouter: ViewRouterProtocol {
    static func createModule() -> UIViewController {
        let view = View()
        let presenter = ViewPresenter()
        let interactor = ViewInteractor()
        let router = ViewRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}
