//
//  PitchingStats.swift
//  BaseballSeason
//
//  Created by Jon E on 4/11/21.
//

import Foundation

struct PitchingStats: Codable {
    let sportPitchingTm: SportPitchingTm
}

struct CareerPitchingStats: Codable {
    let sportCareerPitching: SportCareerPitching
}

struct SportPitchingTm: Codable {
    let queryResults: PitchingQueryResults
}

struct SportCareerPitching: Codable {
    let queryResults: PitchingQueryResults
}

struct PitchingQueryResults: Codable {
    let row: PitchingRowStats
}

struct PitchingRowStats: Codable {
    let w: String
    let l: String
    let wpct: String
    let g: String
    let ip: String
    let sv: String
    let era: String
    let so: String
    let whip: String
    let bb: String
    let h9: String
    let hr9: String
}
