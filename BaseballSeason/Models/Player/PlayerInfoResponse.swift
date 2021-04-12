//
//  PlayerInfo.swift
//  BaseballSeason
//
//  Created by Jon E on 4/7/21.
//

import Foundation

struct PlayerInfoResponse: Codable {
    let searchPlayerAll: SearchPlayerAll
}

struct SearchPlayerAll: Codable {
    let queryResults: QueryResults1
}

struct QueryResults1: Codable {
    let row: Row1
}

struct Row1: Codable {
    let position: String
    let birthCountry: String
    let weight: String
    let birthState: String
    let heightInches: String
    let birthCity: String
    let heightFeet: String
    let teamAbbrev: String
    let birthDate: String
    let nameDisplayFirstLast: String
}
