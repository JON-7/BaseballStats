//
//  RosterResponse.swift
//  BaseballSeason
//
//  Created by Jon E on 4/12/21.
//

import Foundation

struct RosterResponse: Codable {
    let roster40: Roster40
}

struct Roster40: Codable {
    let queryResults: RosterQueryResults
}

struct RosterQueryResults: Codable {
    let totalSize: String
    let row: [RosterRow]
}

struct RosterRow: Codable {
    let positionTxt: String
    let jerseyNumber: String
    let nameDisplayFirstLast: String
    let playerId: String
}
