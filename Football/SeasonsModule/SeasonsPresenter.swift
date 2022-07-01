//
//  SeasonsPresenter.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit
import Combine

class SeasonsViewPresenter: SeasonsViewPresenterProtocol {
    
    weak var view: SeasonsViewProtocol?
    
    let networkingManager: NetworkingManager
    
    let cancelBag: CancelBag
    
    var leagueId: String
    
    var seasons: [Season]?

    required init(view: SeasonsViewProtocol, networkingManager: NetworkingManager, cancelBag: CancelBag, seasonId: String) {
        self.view = view
        self.networkingManager = networkingManager
        self.cancelBag = cancelBag
        self.leagueId = seasonId
    }
    
    func fetchSeasons(endPoint: Routes) {
        networkingManager.sendRequest(endPoint: endPoint.routes ?? "")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    print("Error passed to future", error)
                }
            } receiveValue: { [weak  self] (result: SeasonsResponse) in
                self?.view?.seasons = result.data.seasons
                self?.seasons = result.data.seasons
                self?.view?.reloadData()
            }.store(in: &cancelBag.subscriptions)
    }
    
    func coordinateToSeasonDetailView(title: String) {
        let detailVC = ModulesBuilder.createSeasonsDetailsModule(with: leagueId, title: title)
        detailVC.seasons = self.seasons
        view?.pushToStands(vc: detailVC)
    }
}

