//
//  LeagueLeaderEndpoint.swift
//  BaseballSeason
//
//  Created by Jon E on 8/28/21.
//

import UIKit

enum LeagueLeaderEndpoint: Endpoint {
    case getLeagueLeaders(stat: Stat, statType: StatType)
    
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
        case .getLeagueLeaders(_, let statType):
            if statType == .hitting {
                return "/json/named.leader_hitting_repeater.bam"
            }
            else {
                return "/json/named.leader_pitching_repeater.bam"
            }
        }
    }
    
    var parameters: [URLQueryItem] {
        let year = Calendar.current.component(.year, from: Date())
        switch self {
        case .getLeagueLeaders(let stat, _):
            let leadingStat = getStat(stat: stat)
            return [URLQueryItem(name: "results", value: "50"),
                    URLQueryItem(name: "season", value: "\(year)"),
                    URLQueryItem(name: "sort_column", value: leadingStat)]
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
