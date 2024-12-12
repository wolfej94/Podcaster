//
//  ViewRouter.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import UIKit

protocol ViewRouterProtocol: AnyObject {
    func showAlert()
}

class ViewRouter: ViewRouterProtocol {

    private weak var view: View!

    static func build() -> View {
        let view = View()
        let presenter = ViewPresenter()
        let interactor = ViewInteractor()
        let router = ViewRouter()

        router.view = view
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }

    func showAlert() {
        let alert = UIAlertController(title: "Test", message: "Test", preferredStyle: .alert)
        view.present(alert, animated: true)
    }
}
