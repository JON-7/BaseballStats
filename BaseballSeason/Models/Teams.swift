//
//  Response.swift
//  BaseballSeason
//
//  Created by Jon E on 4/1/21.
//

import Foundation

// MARK: Model for MLB team stats API

struct Teams: Codable {
    let response: [[Responses]]
}

struct Responses: Codable {
    let position: Int
    let team: Team
    let games: Games
}

struct Team: Codable {
    let name: String
    let logo: String
    let id: Int
}

struct Games: Codable {
    let win: Win
    let lose: Lose
}

struct Win: Codable {
    let total: Int
}

struct Lose: Codable {
    let total: Int
}
