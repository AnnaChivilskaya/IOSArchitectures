//
//  SearchPresenteer.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Rubtsov on 21.02.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewInput: AnyObject {
    var searchResults: [ITunesApp] { get set }
    
    func showError(error: Error)
    func showNoResults()
    func hideNoResults()
    func throbber(show: Bool)
}

protocol SearchViewOutput: AnyObject {
    func viewDidSearch(with query: String)
    func viewDidSelectApp(app: ITunesApp)
}

class SearchPresenter {
    weak var viewInput: (UIViewController & SearchViewInput)?
    let interactor: SearchInteractorInput
    let router: SearchRouterInput
    private let searchService = ITunesSearchService()
    
    init(interactor: SearchInteractorInput, router: SearchRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func openAppDetails(with app: ITunesApp) {
        let appDetailViewController = AppDetailViewController(app: app)
        viewInput?.navigationController?.pushViewController(appDetailViewController, animated: true)
    }
}

extension SearchPresenter: SearchViewOutput {
    func viewDidSearch(with query: String) {
        viewInput?.throbber(show: true)
        interactor.requestApps(with: query) { [weak self] in
            guard let self = self else { return }
            self.viewInput?.throbber(show: false)
            result
                .withValue { apps in
                    guard !apps.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchResults = apps
                }
                .withError { (error) in
                    self.viewInput?.showError(error: error)
                }
        }
    }
    
    func viewDidSelectApp(app: ITunesApp) {
        openAppDetails(with: app)
    }
}
