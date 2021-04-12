//
//  NetworkManager.swift
//  BaseballSeason
//
//  Created by Jon E on 4/1/21.
//

import UIKit

class PlayerNetworkManager {
    static let shared = PlayerNetworkManager()
    
    private let playerInfoApiURL = "https://lookup-service-prod.mlb.com/json/named."
    let year = Calendar.current.component(.year, from: Date())
    
    private init(){}

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
                let playerID = player.row[n].playerId
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
                
                results.append(LeagueLeaders(name: playerName , stat: playerStat, teamName: teamName, playerID: playerID))
            }
            completed(.success(results))
            
        }.resume()
    }
    
    
    func getPlayerInfo(playerName: String, completed: @escaping (Result<PlayerIntro, ErrorMessage>) -> Void) {
        var endpoint = playerInfoApiURL + "search_player_all.bam?sport_code='mlb'&active_sw='Y'&name_part='\(playerName)'"
        endpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
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
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let result = try? decoder.decode(PlayerInfoResponse.self, from: data) else { return }
            let results = result.searchPlayerAll.queryResults.row
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
            completed(.success(playerInfo))
        }.resume()
    }
    
    
    func getPlayerSeasonStats(playerID: String, statType: StatType, completed: @escaping (Result<PlayerStats, ErrorMessage>) -> Void) {
        var endpoint = playerInfoApiURL
        
        if statType == .hitting {
            endpoint = endpoint + "sport_hitting_tm.bam?league_list_id='mlb'&game_type='R'&season='\(year)'&player_id='\(playerID)'"
        } else {
            endpoint = endpoint + "sport_pitching_tm.bam?league_list_id='mlb'&game_type='R'&season='\(year)'&player_id='\(playerID)'"
        }
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
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
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            
            if statType == .hitting {
                guard let result = try? decoder.decode(HittingStats.self, from: data) else {
                    //MARK: If the player has no stats for the season all stats will show a zero
                    let noHittingStats = PlayerStats(stat1: "0", stat2: "0", stat3: "0", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: ".000", stat10: ".000", stat11: ".000", stat12: "0")
                    completed(.success(noHittingStats))
                    return
                }
                let results = result.sportHittingTm.queryResults.row
                let hitting = PlayerStats(stat1: results.ab, stat2: results.g, stat3: results.r, stat4: results.h, stat5: results.hr, stat6: results.rbi, stat7: results.avg, stat8: results.sb, stat9: results.obp, stat10: results.ops, stat11: results.slg, stat12: results.bb)
                
                completed(.success(hitting))
            } else {
                guard let result = try? decoder.decode(PitchingStats.self, from: data) else {
                    let noPitchingStats = PlayerStats(stat1: "0", stat2: "0", stat3: ".000", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: "0.00", stat10: "0", stat11: "0.00", stat12: "0.00")
                    completed(.success(noPitchingStats))
                    return
                }
                let results = result.sportPitchingTm.queryResults.row
                let pitching = PlayerStats(stat1: results.w, stat2: results.l, stat3: results.wpct, stat4: results.g, stat5: results.ip, stat6: results.sv, stat7: results.era, stat8: results.so, stat9: results.whip, stat10: results.bb, stat11: results.h9, stat12: results.hr9)
                completed(.success(pitching))
            }
        }.resume()
    }
    
    
    func getPlayerCareerStats(playerID: String, statType: StatType, completed: @escaping (Result<PlayerStats, ErrorMessage>) -> Void) {

        var endpoint = playerInfoApiURL
        
        if statType == .hitting {
            endpoint = endpoint + "sport_career_hitting.bam?league_list_id='mlb'&game_type='R'&player_id='\(playerID)'"
        } else {
            endpoint = endpoint + "sport_career_pitching.bam?league_list_id='mlb'&game_type='R'&player_id='\(playerID)'"
        }
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
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
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if statType == .hitting {
                guard let result = try? decoder.decode(CareerHittingStats.self, from: data) else {
                    let noHittingStats = PlayerStats(stat1: "0", stat2: "0", stat3: "0", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: ".000", stat10: ".000", stat11: ".000", stat12: "0")
                    completed(.success(noHittingStats))
                    return
                }
                let results = result.sportCareerHitting.queryResults.row
                let hitting = PlayerStats(stat1: results.ab, stat2: results.g, stat3: results.r, stat4: results.h, stat5: results.hr, stat6: results.rbi, stat7: results.avg, stat8: results.sb, stat9: results.obp, stat10: results.ops, stat11: results.slg, stat12: results.bb)

                completed(.success(hitting))
            } else {
                guard let result = try? decoder.decode(CareerPitchingStats.self, from: data) else {
                    let noPitchingStats = PlayerStats(stat1: "0", stat2: "0", stat3: ".000", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: "0.00", stat10: "0", stat11: "0.00", stat12: "0.00")
                    completed(.success(noPitchingStats))
                    return
                }
                let results = result.sportCareerPitching.queryResults.row
                let pitching = PlayerStats(stat1: results.w, stat2: results.l, stat3: results.wpct, stat4: results.g, stat5: results.ip, stat6: results.sv, stat7: results.era, stat8: results.so, stat9: results.whip, stat10: results.bb, stat11: results.h9, stat12: results.hr9)
                completed(.success(pitching))
            }
        }.resume()
    }
}
