//
//  SearchSongInteractorInput.swift
//  iOSArchitecturesDemo
//
//  Created by Аня on 17.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchSongInteractorInput {
    func requestSong(with query: String, completion: @escaping (Result<[ITunesSong]>) -> Void)
}

class SearchSongInteractor: SearchSongInteractorInput  {
    private let searchService =  ITunesSearchService()
    
    func requestSong(with query: String, completion: @escaping (Result<[ITunesSong]>) -> Void) {
        searchService.getSongs(forQuery: query, completion: completion)
    }
}
