//
//  NetworkManager.swift
//  BaseballSeason
//
//  Created by Jon E on 4/1/21.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private let baseTeamInfoApiURL = "https://api-baseball.p.rapidapi.com/"
    private let playerInfoApiURL = "https://lookup-service-prod.mlb.com/json/named."
    let year = Calendar.current.component(.year, from: Date())
    
    private init(){}
    
    func getStandings(for division: String, completed: @escaping (Result<[DivisionStanding], ErrorMessage>) -> Void) {
        
        var endpoint = baseTeamInfoApiURL + "standings?league=1&season=\(year)&group=\(division)"
        endpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noData))
            return
        }
        print("BEING CALLED")
        print(url)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        let headers = [
            "x-rapidapi-key": Keys.TeamAPIKey,
            "x-rapidapi-host": "api-baseball.p.rapidapi.com"
        ]
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let _ = error {
                completed(.failure(.noData))
                return
            }
            
            guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
                completed(.failure(.noData))
                return
            }
            guard let data = data else {
                completed(.failure(.noData))
                return
            }
            
            guard let result = try? JSONDecoder().decode(Teams.self, from: data) else { return }
            
            var results = [DivisionStanding]()
            
            for n in 0...4 {
                let position = result.response.first![n].position
                let teamName = result.response.first![n].team.name
                let teamID = result.response.first![n].team.id
                let wins = result.response.first![n].games.win.total
                let loses = result.response.first![n].games.lose.total
                let winPercentage = (Double(wins + loses) / Double(wins)) * 0.1
                let standing = DivisionStanding(name: teamName, position: position, wins: wins, loses: loses, teamID: teamID, winPercentage: winPercentage)
                results.append(standing)
            }
            completed(.success(results))
        }.resume()
    }
    
    func getLeagueLeaders(for stat: Stats, statType: StatType, completed: @escaping (Result<[LeagueLeaders], ErrorMessage>) -> Void) {
        
        func getStat(stat: Stats) -> String {
            switch stat {
            case .wins:
                return "w"
            case .saves:
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
        
        let leadingStat = getStat(stat: stat)
        var results = [LeagueLeaders]()
        var endpoint: String
        
        if statType == StatType.hitting {
            endpoint = playerInfoApiURL + "leader_hitting_repeater.bam?results=5&season='\(year)'&sort_column='\(leadingStat)'"
        } else {
            endpoint = playerInfoApiURL + "leader_pitching_repeater.bam?results=5&season='\(year)'&sort_column='\(leadingStat)'"
        }
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let _ = error {
                completed(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.noData))
                return
            }
            
            guard let data = data else {
                completed(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            

            guard let result = try? decoder.decode(LeadersResponse.self, from: data) else { return }
            var player: QueryResults
            if statType == .hitting {
                player = (result.leaderHittingRepeater?.leaderHittingMux.queryResults)!
            } else {
                player = (result.leaderPitchingRepeater?.leaderPitchingMux.queryResults)!
            }
            
            
        
            for n in 0...4 {
                let playerName = player.row[n].nameDisplayFirstLast
                let teamName = player.row[n].teamName
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
                case .saves:
                    playerStat = (player.row[n].sv) ?? "0"
                case .so:
                    playerStat = (player.row[n].so) ?? "0"
                case .whip:
                    playerStat = (player.row[n].whip) ?? "0"
                }
                
                results.append(LeagueLeaders(name: playerName , stat: playerStat, teamName: teamName))
            }
            completed(.success(results))
            
        }.resume()
    }
}
