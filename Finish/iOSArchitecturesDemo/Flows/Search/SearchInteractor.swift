//
//  SearchInteractorInput.swift
//  iOSArchitecturesDemo
//
//  Created by Аня on 17.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchInteractorInput {

func requestApps(with query: String, completion: Result<[ITunesApp> -> Void)
}

final class SearchInteractor: SearchInteractorInput {

    private let searchService = ITunesSearchService()

func requestApps(with query: String, completion: Result<[ITunesApp> -> Void) {
    self.searchService.getApps(forQuery: query, then: completion)
    
    }
}
