//
//  LeaguesPresenter.swift
//  Football
//
//  Created by Denis Svetlakov on 30.06.2022.
//

import UIKit
import Combine

class LeaguesViewPresenter: LeaguesViewPresenterProtocol {

    weak var view: LeaguesViewProtocol?
    
    let networkingManager: NetworkingManager
    
    let cancelBag: CancelBag
    
    var isSearchMode = false

    required init(view: LeaguesViewProtocol, networkingManager: NetworkingManager, cancelBag: CancelBag) {
        self.view = view
        self.networkingManager = networkingManager
        self.cancelBag = cancelBag
    }
    
    func fetchLeagues(endPoint: Routes) {
        networkingManager.sendRequest(endPoint: endPoint.routes ?? "")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    print("Error passed to future", error)
                }
            } receiveValue: { [weak self] (result: LeagueResponse) in
                self?.view?.leagues = result.data
                self?.view?.reloadData()
            }.store(in: &cancelBag.subscriptions)
    }
    
    func coordinateToSeasonView(with id: String, title: String) {
        let detailVC = ModulesBuilder.createSeasonsModule(with: id, title: title)
        view?.pushToSeasons(vc: detailVC)
    }
}
