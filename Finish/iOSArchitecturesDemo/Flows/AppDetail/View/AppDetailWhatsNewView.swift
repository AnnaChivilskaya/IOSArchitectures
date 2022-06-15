//
//  AppDetailWhatsNewView.swift
//  iOSArchitecturesDemo
//
//  Created by Аня on 15.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class AppDetailWhatsNewView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private(set) lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private(set) lazy var lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private(set) lazy var updateInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    private func configureUI() {
        self.addSubview(titleLabel)
        self.addSubview(versionLabel)
        self.addSubview(lastUpdateLabel)
        self.addSubview(updateInfoLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            versionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            versionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            lastUpdatedLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 8),
            lastUpdatedLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            lastUpdatedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            updateInfoLabel.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor, constant: 12),
            updateInfoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            updateInfoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }
}
