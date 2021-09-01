//
//  PlayerInfo.swift
//  BaseballSeason
//
//  Created by Jon E on 4/7/21.
//

import Foundation

struct PlayerIntro {
    let playerName: String
    let teamAbrv: String
    let position: String
    let birthDate: String
    let birthState: String
    let birthCity: String
    let birthCountry: String
    let heightFeet: String
    let heightInches: String
    let weight: String
}

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
