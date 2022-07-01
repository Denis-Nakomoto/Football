//
//  StanadsPresenter.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit
import Combine

class StandsViewPresenter: StandsViewPresenterProtocol {
    
    weak var view: StandsViewProtocol?
    
    let networkingManager: NetworkingManager
    
    let cancelBag: CancelBag
    
    var leagueId: String

    required init(view: StandsViewProtocol, networkingManager: NetworkingManager, cancelBag: CancelBag, leagueId: String) {
        self.view = view
        self.networkingManager = networkingManager
        self.cancelBag = cancelBag
        self.leagueId = leagueId
    }
    
    func fetchStands(endPoint: Routes) {
        networkingManager.sendRequest(endPoint: endPoint.routes ?? "")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    print("Error passed to future", error)
                }
            } receiveValue: { [weak self] (result: StandsResponse) in
                self?.view?.stands = result.data
                self?.view?.reloadData()
            }.store(in: &cancelBag.subscriptions)
    }
    
}
