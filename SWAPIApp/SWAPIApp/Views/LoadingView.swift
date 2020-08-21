//
//  LoadingView.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Subviews
    
    // Add a blurred background so that user can see the TableView loading.
    // This leads to a better user experience for long network calls.
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.text = "Loading characters..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 32
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .clear
        
        insertSubview(blurView, at: 0)
        addSubview(stackView)
        [label, activityIndicator].forEach { stackView.addArrangedSubview($0) }
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        blurView.fillSuperview()
        stackView.center(in: self)
    }
}
