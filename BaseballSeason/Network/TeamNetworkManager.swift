//
//  TeamNetworkManager.swift
//  BaseballSeason
//
//  Created by Jon E on 9/8/21.
//

import Foundation

class TeamNetworkManager {
    static let shared = TeamNetworkManager()
    private init(){}
    
    func getTeamStandingIndex(currentIndex: Int) -> Int {
        if currentIndex == 1 || currentIndex == 7 || currentIndex == 13 || currentIndex == 19 {
            return 0
        } else if currentIndex == 2 || currentIndex == 8 || currentIndex == 14 || currentIndex == 20 {
            return 1
        } else if currentIndex == 3 || currentIndex == 9 || currentIndex == 15 || currentIndex == 21 {
            return 2
        } else if currentIndex == 4 || currentIndex == 10 || currentIndex == 16 || currentIndex == 22 {
            return 3
        } else {
            return 4
        }
    }
    
    func getDivisionIndex(currentIndex: Int) -> Int {
        if currentIndex < 7 {
            return 0
        } else if currentIndex >= 7 && currentIndex < 12 {
            return 1
        } else if currentIndex >= 13 && currentIndex < 18 {
            return 2
        } else {
            return 3
        }
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
}
