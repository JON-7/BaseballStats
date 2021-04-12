//
//  Leaders.swift
//  BaseballSeason
//
//  Created by Jon E on 4/3/21.
//

import Foundation

// MARK: Model for MLB player stats API

struct LeadersResponse: Codable {
    let leaderPitchingRepeater: LeaderPitchingRepeater?
    let leaderHittingRepeater: LeaderHittingRepeater?
}

struct LeaderPitchingRepeater: Codable {
    let leaderPitchingMux: LeaderPitchingMux
}

struct LeaderHittingRepeater: Codable {
    let leaderHittingMux: LeaderHittingMux
}

struct LeaderPitchingMux: Codable {
    let queryResults: QueryResults
}

struct LeaderHittingMux: Codable {
    let queryResults: QueryResults
}

struct QueryResults: Codable {
    let row: [Row]
}

struct Row: Codable {
    let nameDisplayFirstLast: String
    let teamName: String
    let playerId: String
    
    let so: String?
    let w: String?
    let sv: String?
    let era: String?
    let whip: String?
    
    let hr: String?
    let avg: String?
    let sb: String?
    let rbi: String?
    let h: String?
}
