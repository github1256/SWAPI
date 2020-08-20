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
            //setupActivityIndicator()
            configureLabels()
        }
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
            filmsLabel.text = ""
            filmsLabel.numberOfLines = 0
        }
    }
    
    // MARK: - Setup and Configuration
    
    fileprivate func configureLabels() {
        heightLabel.text = person.height
        massLabel.text = person.mass
        hairColorLabel.text = person.hairColor
        skinColorLabel.text = person.skinColor
        eyeColorLabel.text = person.eyeColor
        genderLabel.text = person.gender
    }
    
    private func setupActivityIndicator() {
        filmsLabel.addSubview(activityIndicator)
        activityIndicator.anchor(top: filmsLabel.topAnchor, leading: filmsLabel.leadingAnchor, bottom: filmsLabel.bottomAnchor, trailing: filmsLabel.trailingAnchor)
    }
    
    // MARK: - Subviews
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: - Init
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
