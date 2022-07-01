//
//  SeasonsModel.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import Foundation

struct SeasonsResponse: Codable {
    let status: Bool
    let data: SeasonsData
}

struct SeasonsData: Codable {
    let name, desc, abbreviation: String?
    let seasons: [Season]
}

struct Season: Codable, Hashable {
    let year: Int
    let startDate, endDate, displayName: String
    let types: [TypeElement]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startDate)
    }
    
    static func == (lhs: Season, rhs: Season) -> Bool {
        return lhs.startDate == rhs.startDate
    }
}

struct TypeElement: Codable {
    let id, name, abbreviation, startDate: String
    let endDate: String
    let hasStandings: Bool
}
