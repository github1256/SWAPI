//
//  ViewController.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class SWCharactersListViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    private var viewModel: StarWarsViewModel?
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StarWarsViewModel(delegate: self)
        viewModel?.fetchPeople()
        
        setupViews()
        setupTableView()
    }
    
    // MARK: - Subviews
    
    let loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    // MARK: - Setup
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Star Wars Characters"
        
        [tableView, loadingView].forEach { view.addSubview($0) }
        setupLayouts()
    }
    
    private func setupLayouts() {
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        loadingView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseIdentifier)
    }
}

// MARK: - TableView Delegate and Datasource

extension SWCharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let swCharacterDetailViewController = SWCharacterDetailViewController()
        swCharacterDetailViewController.person = viewModel?.findPerson(at: indexPath.row)
        navigationController?.pushViewController(swCharacterDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else { fatalError("Error dequeuing CharacterCell") }
        /*
          Load an empty cell if it is waiting for data from API call.
          This allows the TableView to load in real time behind the blurred loading view
          and leads to a better user experience for long network calls.
         */
        if !isLoadingCell(for: indexPath) {
            cell.person = viewModel?.findPerson(at: indexPath.row)
        }
        return cell
    }
}

// MARK: - StarWarsViewModelDelegate

extension SWCharactersListViewController: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
        // Reload table view with fetched characters
        tableView.reloadData()
        
        // Remove the loading view when all characters have been fetched
        if viewModel?.totalCount == viewModel?.currentCount {
            loadingView.removeFromSuperview()
        }
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}

// MARK: - Internal Methods

private extension SWCharactersListViewController {
    // Checks if index path row exceeds what is currently loaded
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel?.currentCount ?? 0
    }
}
