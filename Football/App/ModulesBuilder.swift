//
//  ModulesBuilder.swift
//  Football
//
//  Created by Denis Svetlakov on 30.06.2022.
//

import Foundation

protocol Builder {
    static func createLeaguesModule() -> LeaguesViewController
    static func createSeasonsModule(with id: String, title: String) -> SeasonsViewController
    static func createSeasonsDetailsModule(with id: String, title: String) -> StandsViewController
}

class ModulesBuilder: Builder {
    
    static let networkingManager = NetworkingManager()
    static let cancelBag = CancelBag()
    
    static func createLeaguesModule() -> LeaguesViewController {
        let viewController = LeaguesViewController()
        let presenter = LeaguesViewPresenter(view: viewController, networkingManager: networkingManager, cancelBag: cancelBag)
        viewController.presenter = presenter
        return viewController
    }
    
    static func createSeasonsModule(with id: String, title: String) -> SeasonsViewController {
        let viewController = SeasonsViewController()
        viewController.title = title
        let presenter = SeasonsViewPresenter(view: viewController, networkingManager: networkingManager, cancelBag: cancelBag, seasonId: id)
        viewController.presenter = presenter
        return viewController
    }
    
    static func createSeasonsDetailsModule(with id: String, title: String) -> StandsViewController {
        let viewController = StandsViewController()
        viewController.title = title
        let presenter = StandsViewPresenter(view: viewController, networkingManager: networkingManager, cancelBag: cancelBag, leagueId: id)
        viewController.presenter = presenter
        return viewController
    }
}
