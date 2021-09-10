//
//  NetworkManager.swift
//  BaseballSeason
//
//  Created by Jon E on 4/1/21.
//

import UIKit

class PlayerNetworkManager {
    static let shared = PlayerNetworkManager()
    private init(){}
    
    var favorites = [FavoritePlayers]()
    
    func getPlayerInfo(for data: PlayerInfoResponse) -> PlayerIntro {
        let results = data.searchPlayerAll.queryResults.row
        let playerName = results.nameDisplayFirstLast
        let teamAbrv = results.teamAbbrev
        let position = results.position
        let birthDate = results.birthDate
        let city = results.birthCity
        let state = results.birthState
        let country = results.birthCountry
        let heightFeet = results.heightFeet
        let heightInches = results.heightInches
        let weight = results.weight
        
        let playerInfo = PlayerIntro(playerName: playerName, teamAbrv: teamAbrv, position: position, birthDate: birthDate, birthState: state, birthCity: city, birthCountry: country, heightFeet: heightFeet, heightInches: heightInches, weight: weight)
        return playerInfo
    }
    
    func getSeasonHittingStats(data: HittingStats?) -> PlayerStats {
        guard let hittingData = data else {
            return PlayerStats(stat1: "0", stat2: "0", stat3: "0", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: ".000", stat10: ".000", stat11: ".000", stat12: "0")
        }
        
        let results = hittingData.sportHittingTm.queryResults.row
        let hittingStats = PlayerStats(stat1: results.ab, stat2: results.g, stat3: results.r, stat4: results.h, stat5: results.hr, stat6: results.rbi, stat7: results.avg, stat8: results.sb, stat9: results.obp, stat10: results.ops, stat11: results.slg, stat12: results.bb)
        return hittingStats
    }
    
    //MARK: Season pitching stats
    func getSeasonPitchingStats(data: PitchingStats?) -> PlayerStats {
        guard let pitchingData = data else {
            return PlayerStats(stat1: "0", stat2: "0", stat3: ".000", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: "0.00", stat10: "0", stat11: "0.00", stat12: "0.00")
        }
        
        let results = pitchingData.sportPitchingTm.queryResults.row
        let pitchingStats = PlayerStats(stat1: results.w, stat2: results.l, stat3: results.wpct, stat4: results.g, stat5: results.ip, stat6: results.sv, stat7: results.era, stat8: results.so, stat9: results.whip, stat10: results.bb, stat11: results.h9, stat12: results.hr9)
        return pitchingStats
    }
    
    
    func getCareerHittingStats(data: CareerHittingStats?) -> PlayerStats {
        guard let hittingData = data else {
            return PlayerStats(stat1: "0", stat2: "0", stat3: "0", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: ".000", stat10: ".000", stat11: ".000", stat12: "0")
        }
        
        let results = hittingData.sportCareerHitting.queryResults.row
        let hittingStats = PlayerStats(stat1: results.ab, stat2: results.g, stat3: results.r, stat4: results.h, stat5: results.hr, stat6: results.rbi, stat7: results.avg, stat8: results.sb, stat9: results.obp, stat10: results.ops, stat11: results.slg, stat12: results.bb)
        return hittingStats
    }
    
    func getCareerPitchingStats(data: CareerPitchingStats?) -> PlayerStats {
        guard let pitchingData = data else {
            return PlayerStats(stat1: "0", stat2: "0", stat3: ".000", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: "0.00", stat10: "0", stat11: "0.00", stat12: "0.00")
        }
        
        let results = pitchingData.sportCareerPitching.queryResults.row
        let pitchingStats = PlayerStats(stat1: results.w, stat2: results.l, stat3: results.wpct, stat4: results.g, stat5: results.ip, stat6: results.sv, stat7: results.era, stat8: results.so, stat9: results.whip, stat10: results.bb, stat11: results.h9, stat12: results.hr9)
        return pitchingStats
    }
    
    func getLeagueLeaderArray(data: LeadersResponse, stat: Stat, statType: StatType) -> [LeagueLeaders] {
        var leagueLeaders = [LeagueLeaders]()
        
        var player: QueryResults
        if statType == .hitting {
            player = (data.leaderHittingRepeater?.leaderHittingMux.queryResults)!
        } else {
            player = (data.leaderPitchingRepeater?.leaderPitchingMux.queryResults)!
        }
        
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
}
