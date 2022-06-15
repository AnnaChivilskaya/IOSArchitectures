//
//  SearchPresenteer.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Rubtsov on 21.02.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import UIKit

protocol SearchSongViewInput: AnyObject {
    var searchResults: [ITunesSong] { get set }
    
    func showError(error: Error)
    func showNoResults()
    func hideNoResults()
    func throbber(show: Bool)
}

protocol SearchSongViewOutput: AnyObject {
    func viewDidSearch(with query: String)
    func viewDidSelectSong(song: ITunesSong)
}

class SearchSongPresenter {
    weak var viewInput: (UIViewController & SearchSongViewInput)?
    
    let interactor: SearchSongInteractorInput
    let router: SearchSongRouterInput
    
    private let searchService = ITunesSearchService()
    
    init(interactor: SearchSongInteractorInput, router: SearchSongRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func openSongDetails(with song: ITunesSong) {
        let songDetailViewController = SongDetailViewController(song: song)
        viewInput?.navigationController?.pushViewController(songDetailViewController, animated: true)
    }
}

extension SearchSongPresenter: SearchSongViewOutput {
    func viewDidSearch(with query: String) {
        viewInput?.throbber(show: true)
        interactor.requestSongs(with: query) { [weak self] in
            guard let self = self else { return }
            self.viewInput?.throbber(show: false)
            result
                .withValue { songs in
                    guard !songs.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchResults = songs
                }
                .withError { (error) in
                    self.viewInput?.showError(error: error)
                }
        }
    }
    
    func viewDidSelectSong(song: ITunesSong) {
        openSongDetails(with: song)
    }
}

