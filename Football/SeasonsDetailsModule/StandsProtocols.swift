//
//  StandsProtocols.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import Foundation


protocol StandsViewProtocol: AnyObject {
    
    var stands: StandsData? { get set }

    func reloadData()
}

protocol StandsViewPresenterProtocol: AnyObject {
    
    var view: StandsViewProtocol? { get set }
    
    var networkingManager: NetworkingManager { get }
    
    var leagueId: String { get set }
    
    init(view: StandsViewProtocol, networkingManager: NetworkingManager, cancelBag: CancelBag, leagueId: String)
    
    func fetchStands(endPoint: Routes)

}
