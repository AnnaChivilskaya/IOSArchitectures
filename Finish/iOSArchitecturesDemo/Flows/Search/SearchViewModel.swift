//
//  SearchNewModel.swift
//  iOSArchitecturesDemo
//
//  Created by Аня on 16.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

struct SearchAppCellModel {
    let appName: String
    let company: String?
    let averageRating: Float?
    let downloadState: DownloadingApp.DownloadState
}

final class SearchViewModel {
   
    let cellModels = Observable<[SearchAppCellModel]>([])
    let isLoading = Observable<Bool>(false)
    let showEmptyResults = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    
    weak var viewController: UIViewController?
    
    private var apps: [ITunesApp] = []
    
    private let searchService: SearchServiceInterface
    private let downloadAppsService: DownloadAppsServiceInterface
   
    init(searchService: SearchServiceInterface, downloadAppsService: DownloadAppsServiceInterface) {
        self.searchService = searchService
        self.downloadAppsService = downloadAppsService
        downloadAppsService.onProgressUpdate = { [weak self] in
            guard let self = self else { return }
            self.cellModels.value = self.viewModels()
        }
    }

    func search(for query: String) {
        self.isLoading.value = true
        self.searchService.getApps(forQuery: query) { [weak self] result in
            guard let self = self else { return }
            result
                .withValue { apps in
                    self.apps = apps
                    self.cellModels.value = self.viewModels()
                    self.isLoading.value = false
                    self.showEmptyResults.value = apps.isEmpty
                    self.error.value = nil
                } .withError {
                    self.apps = []
                    self.cellModels.value = []
                    self.isLoading.value = false
                    self.showEmptyResults.value = true
                    self.error.value = $0
                }
        }
    }
    func didSelectApp(_ appViewModel: SearchAppCellModel) {
        guard let app = self.app(with: appViewModel) else { return }
        let appDetaillViewController = AppDetailViewController(app: app)
        
        self.viewController?.navigationController?.pushViewController(appDetaillViewController, animated: true)
    }
    
    func didTapDownloadApp(_ appViewModel: SearchAppCellModel) {
        guard let app = self.app(with: appViewModel) else { return }
        self.downloadAppsService.startDownloadApp(app)
    }
    
    private func viewModels() -> [SearchAppCellModel] {
        return self.apps.compactMap { app -> SearchAppCellModel in
            let downloadingApp = self.downloadAppsService.downloadingApps.first { downloadingApp -> Bool in
                return downloadingApp.app.appName == app.appName }
            return SearchAppCellModel(appName: app.appName, company: app.company,
                                      averageRating: app.averageRating,
                                      downloadState: downloadingApp?.downloadState ?? .notStarted)
        }
    }
    
    private func app(with viewModel: SearchAppCellModel) -> ITunesApp? { return self.apps.first { viewModel.appName == $0.appName }
    }
}
