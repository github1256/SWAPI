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
        viewModel = StarWarsViewModel(delegate: self)
        viewModel.fetchPeople()
        
        setupViews()
        setupTableView()
    }
    
    deinit {
        print("ViewController memory being reclaimed...")
    }
    
    // MARK: - Subviews
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()
    
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
        
        view.addSubview(indicatorView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        indicatorView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        indicatorView.center(in: view)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
    }
    
}

// MARK: - TableView Delegate and Datasource

extension SWCharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if viewModel.currentCount == 0 {
//            return 500
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return indicatorView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
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
        indicatorView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}



//private extension SWCharactersListViewController {
//    func isLoadingCell(for indexPath: IndexPath) -> Bool {
//        return indexPath.row >= viewModel.currentCount
//    }
//}
