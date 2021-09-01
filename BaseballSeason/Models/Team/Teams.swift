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


func getDivisionStandings(data: Teams) -> [DivisionStanding] {
    var teamResults = [DivisionStanding]()
    
    for n in 0...4 {
        let results = data.response.first![n]
        let position = results.position
        let teamName = results.team.name
        let teamID = results.team.id
        let wins = results.games.win.total
        let loses = results.games.lose.total
        let winPercentage = (Double(wins + loses) / Double(wins)) * 0.1
        let standing = DivisionStanding(name: teamName, position: position, wins: wins, loses: loses, teamID: teamID, winPercentage: winPercentage)
        teamResults.append(standing)
    }
    return teamResults
}
