//
//  AppDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 20.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
    let app: ITunesApp
    
    lazy var headerViewController = AppDetailHeaderViewController(app: self.app)
    lazy var whatsNewViewController = AppDetailWhatsNewViewController(app: app)
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        addWhatsNewViewController()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
        self.addHeaderViewController()
        self.addDescriptionViewController()
    }
    
    private func addHeaderViewController() {
        self.addChild(self.headerViewController)
        self.view.addSubview(self.headerViewController.view)
        self.headerViewController.didMove(toParent: self)
        
        self.headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.headerViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.headerViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
    }
    
    private func addDescriptionViewController() {
     
        let descriptionViewController = UIViewController()
        
        self.addChild(descriptionViewController)
        self.view.addSubview(descriptionViewController.view)
        descriptionViewController.didMove(toParent: self)
        
        descriptionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionViewController.view.topAnchor.constraint(equalTo: self.headerViewController.view.bottomAnchor),
            descriptionViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            descriptionViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            descriptionViewController.view.heightAnchor.constraint(equalToConstant: 250.0)
            ])
    }
    private func addWhatsNewViewController() {
        self.addChild(whatsNewViewController)
        self.view.addSubview(whatsNewViewController.view)
        whatsNewViewController.didMove(toParent: self)
        
        whatsNewViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            whatsNewViewController.view.topAnchor.constraint(equalTo: self.headerViewController.view.safeAreaLayoutGuide.bottomAnchor),
            whatsNewViewController.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            whatsNewViewController.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
}

final class AppDetailHeaderViewController: UIViewController {
    
    // MARK: - Properties
    
    private let app: ITunesApp
    
    private let imageDownloader = ImageDownloader()
    
    private var appDetailHeaderView: AppDetailHeaderView {
        return self.view as! AppDetailHeaderView
    }
    
    // MARK: - Init
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDetailHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
    }
    
    // MARK: - Private
    
    private func fillData() {
        self.downloadImage()
        self.appDetailHeaderView.titleLabel.text = app.appName
        self.appDetailHeaderView.subtitleLabel.text = app.company
        self.appDetailHeaderView.ratingLabel.text = app.averageRating.flatMap { "\($0)" }
    }
    
    private func downloadImage() {
        guard let url = self.app.iconUrl else { return }
        self.imageDownloader.getImage(fromUrl: url) { [weak self] (image, _) in
            self?.appDetailHeaderView.imageView.image = image
        }
    }
}
