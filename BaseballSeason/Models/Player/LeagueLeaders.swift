//
//  LeagueLeaders.swift
//  BaseballSeason
//
//  Created by Jon E on 4/3/21.
//

import Foundation

struct LeagueLeaders {
    let name: String
    let stat: String
    let teamName: String
    let playerID: String
    let league: String
}

func getLeagueLeaderArray(data: LeadersResponse, stat: Stat, statType: StatType) -> [LeagueLeaders] {
    var leagueLeaders = [LeagueLeaders]()
    
    var player: QueryResults
    if statType == .hitting {
        player = (data.leaderHittingRepeater?.leaderHittingMux.queryResults)!
    } else {
        player = (data.leaderPitchingRepeater?.leaderPitchingMux.queryResults)!
    }
    
    //MARK: Retrieving the top 50 players that will later be filtered
    for n in 0..<player.row.count {
        let playerName = player.row[n].nameDisplayFirstLast
        let teamName = player.row[n].teamName
        let playerID = player.row[n].playerId
        let league = player.row[n].league
        let playerStat: String
        
        switch stat {
        case .avg:
            playerStat = (player.row[n].avg) ?? "0"
        case .sb:
            playerStat = (player.row[n].sb) ?? "0"
        case .hr:
            playerStat = (player.row[n].hr) ?? "0"
        case .rbi:
            playerStat = (player.row[n].rbi) ?? "0"
        case .hits:
            playerStat = (player.row[n].h) ?? "0"
        case .era:
            playerStat = (player.row[n].era) ?? "0"
        case .wins:
            playerStat = (player.row[n].w) ?? "0"
        case .sv:
            playerStat = (player.row[n].sv) ?? "0"
        case .so:
            playerStat = (player.row[n].so) ?? "0"
        case .whip:
            playerStat = (player.row[n].whip) ?? "0"
        }
        
        leagueLeaders.append(LeagueLeaders(name: playerName , stat: playerStat, teamName: teamName, playerID: playerID, league: league))
    }
    return leagueLeaders
}

func getStat(stat: Stat) -> String {
    switch stat {
    case .wins:
        return "w"
    case .sv:
        return "sv"
    case .so:
        return "so"
    case .whip:
        return "whip"
    case .avg:
        return "avg"
    case .sb:
        return "sb"
    case .hr:
        return "hr"
    case .rbi:
        return "rbi"
    case .hits:
        return "h"
    case .era:
        return "era"
    }
}
