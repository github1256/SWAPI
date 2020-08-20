//
//  SWCharacterDetailView.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class SWCharacterDetailView: UIViewController {
    
    // MARK: - Variables and Properties
    
    private var viewModel: StarWarsViewModel!
    var films: [Film] = []
    var person: Person! {
        didSet {
            
            viewModel = StarWarsViewModel(delegate: self)
            person.films.forEach { (filmUrl) in
                viewModel.fetchFilms(with: filmUrl)
            }
            
            
            
            characterDetailView.person = self.person
            setupTitleView()
            setupViews()
            setupNavigationBarButtons()
        }
    }
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
    
    // MARK: - Subviews
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .systemBackground
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
        [scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(characterDetailView)
    }

    private func setupTitleView() {
        let navTitle = person.name.customizeString(color: UIColor.label, fontSize: 20.0, weight: .bold)
        let navSubtitle = "Birth Year: \(person.birthYear)".customizeString(color: .secondaryLabel, fontSize: 14.0, weight: .light)
        navTitle.append(NSMutableAttributedString(string: "\n"))
        navTitle.append(navSubtitle)
        titleLabel.attributedText = navTitle
        navigationItem.titleView = titleLabel
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        ]
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - StarWarsViewModelDelegate

typealias FilmTuple = (title: String, openingCrawlWordCount: Int)

extension SWCharacterDetailView: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
        let films = viewModel.findFilms()
        
        // check if all film data has been fetched
        if person.films.count == films.count {
            var filmTuples: [FilmTuple] = []
            films.forEach { film in
                
                filmTuples.append(FilmTuple(title: film.title, openingCrawlWordCount: film.openingCrawl.wordCount))
            }
            
            
//            filmsLabel.text = filmTuples.map {
//                "\($0.title) " + "(opening crawl word count: \($0.openingCrawlWordCount))"
//            }.joined(separator: "\n")
            
            
            
            
            
            
            
        }
    }
    
    func fetchDidFail(with title: String, description: String) {
        AlertService.showAlert(title: title, message: description, on: self)
    }
}
