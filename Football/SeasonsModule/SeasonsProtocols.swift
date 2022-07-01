//
//  SeasonsProtocols.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit

protocol SeasonsViewProtocol: AnyObject {
    
    var seasons: [Season]? { get set }
    
    func pushToStands(vc: UIViewController)

    func reloadData()
}

protocol SeasonsViewPresenterProtocol: AnyObject {
    
    var view: SeasonsViewProtocol? { get set }
    
    var networkingManager: NetworkingManager { get }
    
    var leagueId: String { get set }
    
    init(view: SeasonsViewProtocol, networkingManager: NetworkingManager, cancelBag: CancelBag, seasonId: String)
    
    func fetchSeasons(endPoint: Routes)
    
    func coordinateToSeasonDetailView(title: String)
}
