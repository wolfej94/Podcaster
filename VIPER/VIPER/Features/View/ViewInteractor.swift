//
//  ViewInteractor.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import Foundation

protocol ViewInteractorProtocol: AnyObject {
    // Define methods for business logic
}

class ViewInteractor: ViewInteractorProtocol {
    var presenter: ViewPresenterProtocol?
}
