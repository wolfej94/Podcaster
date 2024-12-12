//
//  View.swift
//  VIPER
//
//  Created by James Wolfe on 04/12/2024.
//

import UIKit

protocol ViewProtocol: AnyObject {

}

class View: UIViewController, ViewProtocol {
    var presenter: ViewPresenterProtocol?

    init() {
        super.init(nibName: "View", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        presenter?.didTapButton()
    }

}
