//
//  ViewController.swift
//  
//
//  Created by James Wolfe on 13/12/2024.
//

import UIKit

protocol TableViewDataSource: UITableViewDataSource {
    var data: [String] { get }
    func reverseList()
}

final class ViewControllerDataSource: NSObject, TableViewDataSource {

    var data = ["Apple", "Orange", "Banana", "Grape", "Peach"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    func reverseList() {
        self.data = self.data.reversed()
    }

}

class ViewController: UIViewController {

    private let dataSource: TableViewDataSource
    private lazy var tableView = {
        let view = UITableView()
        view.dataSource = self.dataSource
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        return view
    }()

    init(dataSource: TableViewDataSource = ViewControllerDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: "", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource.reverseList()
        tableView.reloadData()
    }

}
