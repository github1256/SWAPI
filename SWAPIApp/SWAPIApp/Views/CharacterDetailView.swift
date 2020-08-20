//
//  CharacterDetailView.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class CharacterDetailView: UIView {
    
    // MARK: - Variables and Properties
    
    private var viewModel: StarWarsViewModel!
    var films: [Film] = []
    var person: Person! {
        didSet {
            viewModel = StarWarsViewModel(delegate: self)
            person.films.forEach { (filmUrl) in
                viewModel.fetchFilms(with: filmUrl)
            }
            configureLabels()
        }
    }
    
    fileprivate func configureLabels() {
        heightLabel.text = person.height
        massLabel.text = person.mass
        hairColorLabel.text = person.hairColor
        skinColorLabel.text = person.skinColor
        eyeColorLabel.text = person.eyeColor
        genderLabel.text = person.gender
    }
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var skinColorLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var filmsLabel: UILabel! {
        didSet {
            if films.isEmpty {
                filmsLabel.text = ""
            }
            filmsLabel.numberOfLines = 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // MARK: - Lifecycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        print("CharacterDetailView memory being reclaimed...")
    }
    
}

// MARK: - StarWarsViewModelDelegate

typealias FilmTuple = (title: String, openingCrawlWordCount: Int)

extension CharacterDetailView: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
        let films = viewModel.findFilms()
        
        // check if all film data has been fetched
        if person.films.count == films.count {
            var filmTuples: [FilmTuple] = []
            films.forEach { film in
                
                filmTuples.append(FilmTuple(title: film.title, openingCrawlWordCount: film.openingCrawl.wordCount))
            }
            
            
            filmsLabel.text = filmTuples.map {
                "\($0.title) " + "(opening crawl word count: \($0.openingCrawlWordCount))"
            }.joined(separator: "\n")
            
            
            
            
            
            
            
        }
    }
    
    func fetchDidFail(with title: String, description: String) {
        //        AlertService.showAlert(title: title, message: description, on: self)
    }
}
