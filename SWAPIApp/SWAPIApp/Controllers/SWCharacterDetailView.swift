//
//  SWCharacterDetailView.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

enum HeaderSection: Int, CaseIterable {
    case name, dateOfBirth, physicalAttributes, films
    
    static func numberOfSections() -> Int {
        return self.allCases.count
    }
    
    var title: String {
        switch self {
        case .name: return "Name"
        case .dateOfBirth: return "Date of Birth"
        case .physicalAttributes: return "Physical Attributes"
        case .films: return "Films"
        }
    }
}

class SWCharacterDetailView: UIViewController {
    
    // MARK: - Variables and Properties
    
    var person: Person! {
        didSet {
            view.backgroundColor = .white
            
            setupNavigationBar()
            
            //navigationItem.title = "\(person.name), born \(person.birthYear)"
        }
    }
    
    // MARK: - Subviewss
    
    let characterDetailView: CharacterDetailView = {
        let view = CharacterDetailView()
        return view
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBarButtons()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        [characterDetailView].forEach { view.addSubview($0) }
        setupLayouts()
    }
    
    private func setupLayouts() {
        characterDetailView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        
        let navigationTitle = NSMutableAttributedString(string: person.name, attributes:
            [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold)
            ]
        )
        
        let navigationSubtitle = NSMutableAttributedString(string: "date of birth: \(person.birthYear)", attributes:
            [
                NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)
            ]
        )
        
        navigationTitle.append(NSMutableAttributedString(string: "\n"))
        navigationTitle.append(navigationSubtitle)

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.attributedText = navigationTitle
        self.navigationItem.titleView = titleLabel
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        ]
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    // MARK: - TableView Delegate and Datasource
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return HeaderSection.numberOfSections()
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return HeaderSection(rawValue: section)?.title
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 4 {
//            return person.films.count
//        }
//
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        return cell
//    }
    
}
