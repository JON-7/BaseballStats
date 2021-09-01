//
//  PlayerInfoEndpoint.swift
//  BaseballSeason
//
//  Created by Jon E on 8/28/21.
//

import UIKit

enum PlayerInfoEndpoint: Endpoint {
    case getPlayerInfo(playerName: String)
    case getPlayerSeasonStats(playerID: String, statType: StatType)
    case getPlayerCareerStats(playerID: String, statType: StatType)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "lookup-service-prod.mlb.com"
        }
    }
    
    var path: String {
        switch self {
        case .getPlayerInfo:
            return "/json/named.search_player_all.bam"
        case .getPlayerSeasonStats(_, let statType):
            if statType == .hitting {
                return "/json/named.sport_hitting_tm.bam"
            } else {
                return "/json/named.sport_pitching_tm.bam"
            }
        case .getPlayerCareerStats(_, let statType):
            if statType == .hitting {
                return "/json/named.sport_career_hitting.bam"
            } else {
                return "/json/named.sport_career_pitching.bam"
            }
        }
    }
    
    var parameters: [URLQueryItem] {
        let year = Calendar.current.component(.year, from: Date())
        switch self {
        case .getPlayerInfo(let playerName):
            return [URLQueryItem(name: "sport_code", value: "'mlb'"),
                    URLQueryItem(name: "active_sw", value: "'Y'"),
                    URLQueryItem(name: "name_part", value: "'\(playerName)'")]
            
        case .getPlayerSeasonStats(let playerID, _):
            return [URLQueryItem(name: "league_list_id", value: "'mlb'"),
                    URLQueryItem(name: "game_type", value: "'R'"),
                    URLQueryItem(name: "season", value: "'\(year)'"),
                    URLQueryItem(name: "player_id", value: "'\(playerID)'")]
            
        case .getPlayerCareerStats(let playerID, _):
            return [URLQueryItem(name: "league_list_id", value: "'mlb'"),
                    URLQueryItem(name: "game_type", value: "'R'"),
                    URLQueryItem(name: "player_id", value: "'\(playerID)'")]
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
}
