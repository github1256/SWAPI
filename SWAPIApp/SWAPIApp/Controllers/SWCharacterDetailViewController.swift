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
    typealias FilmTuple = (title: String, openingCrawlWordCount: Int)
    
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
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func setupTitleView() {
        let navTitle = person.name.customizeString(color: UIColor.label, fontSize: 18.0, weight: .bold)
        let navSubtitle = "Birth Year: \(person.birthYear)".customizeString(color: .secondaryLabel, fontSize: 14.0, weight: .light)
        navTitle.append(NSMutableAttributedString(string: "\n"))
        navTitle.append(navSubtitle)
        titleLabel.attributedText = navTitle
        navigationItem.titleView = titleLabel
    }
}

// MARK: - StarWarsViewModelDelegate

var filmString: String = ""

extension SWCharacterDetailViewController: StarWarsViewModelDelegate {
    func fetchDidSucceed() {

        // Update the UI if all the film data has been fetched
        let films = viewModel?.findFilms()
        var filmTuples: [FilmTuple] = []
        if person.films.count == films?.count {
            films?.forEach {
                filmTuples.append(FilmTuple(title: $0.title, openingCrawlWordCount: $0.openingCrawl.wordCount))
            }
            // For every film, create a string with its title and opening crawl word count
            // Create a separate line for each film
            filmString = filmTuples.map {
                "\($0.title) " + "(opening crawl: \($0.openingCrawlWordCount))"
            }.joined(separator: "\n\n")
            tableView.reloadData()
        }
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}

enum Attributes: Int, CaseIterable {
    case height, mass, hairColor, skinColor, eyeColor, gender, films
    
    var title: String {
        switch self {
        case .height: return "Height (cm)"
        case .mass: return "Mass (kg)"
        case .hairColor: return "Hair Color"
        case .skinColor: return "Skin Color"
        case .eyeColor: return "Eye Color"
        case .gender: return "Gender"
        case .films: return "Films"
        }
    }

    static func getSection(_ section: Int) -> Attributes {
        return self.allCases[section]
    }
    
}

extension SWCharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Attributes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Attributes(rawValue: section)?.title
    }
    
    // MARK: - Rows
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseIdentifier, for: indexPath) as? DetailCell else { fatalError("Error dequeuing DetailCell") }
        switch Attributes.getSection(indexPath.section) {
        case .height: cell.infoLabel?.text = person.height
        case .mass: cell.infoLabel?.text = person.mass
        case .hairColor: cell.infoLabel?.text = person.hairColor
        case .skinColor: cell.infoLabel?.text = person.skinColor
        case .eyeColor: cell.infoLabel?.text = person.eyeColor
        case .gender: cell.infoLabel?.text = person.gender
        case .films: cell.infoLabel?.text = filmString
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
