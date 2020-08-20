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
        navigationController?.navigationBar.prefersLargeTitles = true
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
        let swCharacterDetailView = SWCharacterDetailView()
        swCharacterDetailView.person = viewModel.findPerson(at: indexPath.row)
        let navController = UINavigationController(rootViewController: swCharacterDetailView)
        navigationController?.present(navController, animated: true, completion: nil)
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else { fatalError("Error dequeuing CharacterCell") }
        

//        cell.podcast = self.podcasts[indexPath.row]
//        return cell
        
        
        if isLoadingCell(for: indexPath) {
            cell.textLabel?.text = ""
        } else {
            cell.person = viewModel.findPerson(at: indexPath.row)
            
            //cell.textLabel?.text = viewModel.findPerson(at: indexPath.row).name
        }
        return cell
    }
}

// MARK: - StarWarsViewModelDelegate

extension SWCharactersListViewController: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
        tableView.reloadData()
        
        if viewModel.totalCount == viewModel.currentCount {
            loadingView.removeFromSuperview()
        }
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}

private extension SWCharactersListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
}
