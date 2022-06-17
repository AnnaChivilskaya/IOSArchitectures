//
//  ViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 14.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var searchResults = [SearchAppCellModel]() {
        didSet {
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Private Properties
    
    private let viewModel: SearchViewModel
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private let searchService = ITunesSearchService()
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyResultView = UIView()
    private let emptyResultLabel = UILabel()
    
    // MARK: - Construction
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchView.searchBar.delegate = self
        self.searchView.tableView.register(AppCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
        
        self.bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
    private func bindViewModel() {
        viewModel.isLoading.addObserver(self) { [weak self] (isLoading,_) in
            self?.throbber(show: isLoading)
        }
        
        self.viewModel.error.addObserver(self) { [weak self] (error, _) in if let error = error {
        self?.showError(error: error)
            
        }
    }
        self.viewModel.showEmptyResults.addObserver(self) { [weak self] (showEmptyResults, _) in
        self?.emptyResultView.isHidden = !showEmptyResults
        self?.tableView.isHidden = showEmptyResults
        }
        
        self.viewModel.cellModels.addObserver(self) { [weak self] (searchResults, _) in
        self?.searchResults = searchResults }
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        
        guard let cell = dequeuedCell as? AppCell else {
            return dequeuedCell
        }
        
        let app = self.searchResults[indexPath.row]
        cell.configure(cell: cell, with: app)
        
        return cell
    }
    
    func configure(cell: AppCell, with:  SearchAppCellModel) {
        cell.titleLabel.text = app.appName
        cell.subtitleLabel = app.company
        cell.ratingLabel = app.averageRating >>- { "\($0)" }
        
        switch app.downloadState {
        case .appStarted:
            cell.downloadProgressLabel.text = nil
        case .inProgress(progress: let progress):
            let progressToShow = round(progress * 100.0) / 100.0
            cell.downloadProgressLabel.text = "\(progressToShow)"
        case .downloaded:
            cell.downloadProgressLabel.text "Загружено"
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = searchResults[indexPath.row]
        viewModel.didSelectApp(app)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        
        viewModel.search(for: query)
    }
}

// MARK: - Input
extension SearchViewController: SearchSongViewInput {
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoResults() {
        self.emptyResultView.isHidden = false
        self.searchResults = []
        self.tableView.reloadData()
    }
    
    func hideNoResults() {
        self.emptyResultView.isHidden = true
    }
    
    func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
}
