//
//  LeaguesModel.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import Foundation

struct LeagueResponse: Codable {
    let status: Bool
    let data: [LeagueData]
}

struct LeagueData: Codable, Hashable {
    let id, name, slug, abbr: String
    let logos: LeaguesLogos
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LeagueData, rhs: LeagueData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LeaguesLogos: Codable {
    let light: String
    let dark: String
}

