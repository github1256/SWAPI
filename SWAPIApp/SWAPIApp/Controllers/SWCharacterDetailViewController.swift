//
//  SWCharacterDetailView.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class SWCharacterDetailViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    private var viewModel: StarWarsViewModel?
    var films: [Film] = []
    var person: Person! {
        didSet {
            viewModel = StarWarsViewModel(delegate: self)
            person.films.forEach { filmUrl in
                viewModel?.fetchFilm(with: filmUrl)
            }
            setupViews()
            setupTitleView()
            setupTableView()
        }
    }
    var filmString: String = ""
    
    // MARK: - Subviews
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.tableView.tableHeaderView?.layoutIfNeeded()
            self.tableView.tableHeaderView = self.tableView.tableHeaderView
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(DetailCell.nib, forCellReuseIdentifier: DetailCell.reuseIdentifier)
        tableView.register(DetailHeader.self, forHeaderFooterViewReuseIdentifier: DetailHeader.reuseIdentifier)
    }

    private func setupTitleView() {
        let navTitle = person.name.customizeString(color: UIColor.label, fontSize: 20.0, weight: .bold)
        let navSubtitle = "Birth Year: \(person.birthYear)".customizeString(color: .secondaryLabel, fontSize: 16.0, weight: .light)
        navTitle.append(NSMutableAttributedString(string: "\n"))
        navTitle.append(navSubtitle)
        titleLabel.attributedText = navTitle
        navigationItem.titleView = titleLabel
    }
}

// MARK: - StarWarsViewModelDelegate

extension SWCharacterDetailViewController: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
        // Update the UI if all the film data has been fetched
        let films = viewModel?.findFilms()
        guard person.films.count == films?.count else { return }
        
        // For every film, create a string with its title and opening crawl word count
        // Create a separate line for each film
        filmString = films?.map {
            "\($0.title) " + "(opening crawl: \($0.openingCrawl.wordCount))"
        }.joined(separator: "\n\n") ?? ""
        tableView.reloadData()
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}

// MARK: - TableView Delegate and Datasource

extension SWCharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Attributes.getCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeader.reuseIdentifier) as? DetailHeader else { fatalError("Error dequeuing DetailHeader") }
        header.section = section
        return header
    }
    
    // MARK: - Rows
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseIdentifier, for: indexPath) as? DetailCell else { fatalError("Error dequeuing DetailCell") }
        switch Attributes.getSection(indexPath.section) {
        case .height: cell.configureCell(with: person.height)
        case .mass: cell.configureCell(with: person.mass)
        case .hairColor: cell.configureCell(with: person.hairColor)
        case .skinColor: cell.configureCell(with: person.skinColor)
        case .eyeColor: cell.configureCell(with: person.eyeColor)
        case .gender: cell.configureCell(with: person.gender)
        case .films:
            cell.configureCell(with: filmString)
            cell.loadingIndicator.isHidden = false
            cell.loadingIndicator.startAnimating()
            
            // Remove loading indicator when films are loaded
            if filmString != "" {
                cell.loadingIndicator.stopAnimating()
            }
        }
        return cell
    }
}
