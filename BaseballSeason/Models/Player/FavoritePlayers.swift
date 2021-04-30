//
//  FavoritePlayers.swift
//  BaseballSeason
//
//  Created by Jon E on 4/14/21.
//

import Foundation

struct FavoritePlayers: Codable {
    let name: String
    let playerID: String
    let isPitcher: Bool
    let teamName: String
}
