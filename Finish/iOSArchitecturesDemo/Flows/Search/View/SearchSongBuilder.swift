//
//  SearchModuleBuilder.swift
//  iOSArchitecturesDemo
//
//  Created by Alexander Rubtsov on 21.02.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

class SearchSongBuilder {
    static func build() -> (UIViewController & SearchSongViewInput) {
        let interactor = SearchSongInteractor()
        let router = SearchSongRouter()
        let presenter = SearchSongPresenter(interactor: interactor, router: router)
        let viewController = SearchSongViewController(presenter: presenter)
        router.viewController = viewController
        presenter.viewInput = viewController as! UIViewController & SearchSongViewInput
        
        return viewController as! UIViewController & SearchSongViewInput
    }
}
