//
//  SearchInteractor.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

protocol SearchInteractorProtocol: AnyObject {

}

final class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?
}
