//
//  LeaguesProtocols.swift
//  Football
//
//  Created by Denis Svetlakov on 30.06.2022.
//

import UIKit

protocol LeaguesViewProtocol: AnyObject {
    
    var leagues: [LeagueData]? { get set }
    
    func pushToSeasons(vc: UIViewController)

    func reloadData()
}

protocol LeaguesViewPresenterProtocol: AnyObject {
    
    var view: LeaguesViewProtocol? { get set }
    
    var networkingManager: NetworkingManager { get }
    
    var isSearchMode: Bool { get set }
    
    init(view: LeaguesViewProtocol, networkingManager: NetworkingManager, cancelBag: CancelBag)
    
    func fetchLeagues(endPoint: Routes)
    
    func coordinateToSeasonView(with id: String, title: String) 
}
