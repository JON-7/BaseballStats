//
//  TeamInfoEndpoint.swift
//  BaseballSeason
//
//  Created by Jon E on 8/29/21.
//

import UIKit

enum TeamInfoEndpoint: Endpoint {
    case getStandings(division: String)
    case getFullRoster(teamID: Int)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getStandings:
            return "api-baseball.p.rapidapi.com"
        case .getFullRoster:
            return "lookup-service-prod.mlb.com"
        }
    }
    
    var path: String {
        switch self {
        case .getStandings:
            return "/standings"
        case .getFullRoster:
            return "/json/named.roster_40.bam"
        }
    }
    
    var parameters: [URLQueryItem] {
        let year = Calendar.current.component(.year, from: Date())
        switch self {
        case .getStandings(let division):
            return [URLQueryItem(name: "league", value: "1"),
                    URLQueryItem(name: "season", value: "\(year)"),
                    URLQueryItem(name: "group", value: "\(division)")]
        case .getFullRoster(let teamID):
            return [URLQueryItem(name: "team_id", value: "\(teamID)")]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getStandings:
            return ["x-rapidapi-key": Keys.TeamAPIKey,
                    "x-rapidapi-host": "api-baseball.p.rapidapi.com"]
        default:
            return [:]
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
}
