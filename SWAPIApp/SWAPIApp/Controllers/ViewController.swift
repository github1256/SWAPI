//
//  ViewController.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APIService.shared.fetchPeople { result in
            switch result {
            case .success(let people):
                print(people)
            case .failure(let error):
                print("Failed to fetch people:", error)
            }
        }
    }
    
    deinit {
        print("ViewController memory being reclaimed...")
    }
    
    // MARK: - Subviews
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Star Wars Characters"
        
        view.addSubview(tableView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

}

// MARK: - TableView Delegate and Datasource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Name"
        return cell
    }
}
