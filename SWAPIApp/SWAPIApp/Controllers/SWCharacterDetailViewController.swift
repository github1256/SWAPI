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
            characterDetailView.person = self.person

            setupViews()
            setupTitleView()
        }
    }
    typealias FilmTuple = (title: String, openingCrawlWordCount: Int)
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)
    
    // MARK: - Subviews
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .systemBackground
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var characterDetailView: CharacterDetailView = {
        let view = CharacterDetailView()
        view.frame.size = contentViewSize
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
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
        view.addSubview(scrollView)
        scrollView.addSubview(characterDetailView)
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
            characterDetailView.filmsLabel.text = filmTuples.map {
                "\($0.title) " + "(opening crawl word count: \($0.openingCrawlWordCount))"
            }.joined(separator: "\n")
            
            characterDetailView.activityIndicator.stopAnimating()
        }
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}
