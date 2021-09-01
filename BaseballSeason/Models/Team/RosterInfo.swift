//
//  RosterInfo.swift
//  BaseballSeason
//
//  Created by Jon E on 4/12/21.
//

import Foundation

struct RosterInfo {
    let position: String
    let name: String
    let number: String
    let playerID: String
    let lastNameFirstName: String
}


func getTeamRoster(data: RosterResponse) -> [RosterInfo] {
    var roster = [RosterInfo]()
    let total = Int(data.roster40.queryResults.totalSize) ?? 40
    
    for n in 0..<total {
        let results = data.roster40.queryResults.row[n]
        let player = RosterInfo(position: results.positionTxt, name: results.nameDisplayFirstLast, number: results.jerseyNumber, playerID: results.playerId, lastNameFirstName: results.nameDisplayLastFirst)
        roster.append(player)
    }
    return roster
}
