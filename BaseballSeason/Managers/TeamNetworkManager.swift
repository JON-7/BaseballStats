//
//  TeamNetworkManager.swift
//  BaseballSeason
//
//  Created by Jon E on 4/12/21.
//

import Foundation

class TeamNetworkManager {
    
    static let shared = TeamNetworkManager()
    private init(){}
    
    private let baseTeamInfoApiURL = "https://api-baseball.p.rapidapi.com/"
    private let playerInfoApiURL = "https://lookup-service-prod.mlb.com/json/named."
    let year = Calendar.current.component(.year, from: Date())
    
    func getStandings(for division: String, completed: @escaping (Result<[DivisionStanding], ErrorMessage>) -> Void) {
        var endpoint = baseTeamInfoApiURL + "standings?league=1&season=\(year)&group=\(division)"
        endpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        let headers = [
            //MARK: Team Baseball API key goes here
            "x-rapidapi-key": Keys.TeamAPIKey,
            "x-rapidapi-host": "api-baseball.p.rapidapi.com"
        ]
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let _ = error {
                completed(.failure(.requestError))
                return
            }
            
            guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
                completed(.failure(.noResponce))
                return
            }
            guard let data = data else {
                completed(.failure(.noData))
                return
            }
            
            guard let result = try? JSONDecoder().decode(Teams.self, from: data) else { return }
            
            var teamResults = [DivisionStanding]()
            
            for n in 0...4 {
                let results = result.response.first![n]
                let position = results.position
                let teamName = results.team.name
                let teamID = results.team.id
                let wins = results.games.win.total
                let loses = results.games.lose.total
                let winPercentage = (Double(wins + loses) / Double(wins)) * 0.1
                let standing = DivisionStanding(name: teamName, position: position, wins: wins, loses: loses, teamID: teamID, winPercentage: winPercentage)
                teamResults.append(standing)
            }
            completed(.success(teamResults))
        }.resume()
    }
    
    func getFullRoster(teamID: Int, completed: @escaping (Result<[RosterInfo], ErrorMessage>) -> Void) {
        let endpoint = playerInfoApiURL + "roster_40.bam?team_id='\(teamID)'"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let _ = error {
                completed(.failure(.requestError))
                return
            }
            
            guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
                completed(.failure(.noResponce))
                return
            }
            
            guard let data = data else {
                completed(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let result = try? decoder.decode(RosterResponse.self, from: data) else { return }
            
            var roster = [RosterInfo]()
            let total = Int(result.roster40.queryResults.totalSize) ?? 40
            
            for n in 0..<total {
                let results = result.roster40.queryResults.row[n]
                let player = RosterInfo(position: results.positionTxt, name: results.nameDisplayFirstLast, number: results.jerseyNumber, playerID: results.playerId, lastNameFirstName: results.nameDisplayLastFirst)
                roster.append(player)
            }
            
            completed(.success(roster))
        }.resume()
    }
}
