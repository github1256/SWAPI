//
//  ViewController.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit
import Combine

class SWCharactersListViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    private var viewModel: StarWarsViewModel!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        
        viewModel = StarWarsViewModel(delegate: self)
        viewModel.fetchPeople()
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Star Wars Characters"
        
        view.addSubview(tableView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
}

// MARK: - TableView Delegate and Datasource

extension SWCharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.findPerson(at: indexPath.row).name
        return cell
    }
}

// MARK: - StarWarsViewModelDelegate

extension SWCharactersListViewController: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func fetchDidFail(with reason: String) {
        AlertService.showAlert(title: "Warning", message: reason, on: self)
    }
}
