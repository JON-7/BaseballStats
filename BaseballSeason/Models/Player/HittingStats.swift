//
//  SeasonStats.swift
//  BaseballSeason
//
//  Created by Jon E on 4/10/21.
//

import UIKit

struct HittingStats: Codable {
    let sportHittingTm: SportHittingTm
}

struct CareerHittingStats: Codable {
    let sportCareerHitting: SportCareerHitting
}

struct SportHittingTm: Codable {
    let queryResults: SeasonQueryResults
}

struct SportCareerHitting: Codable {
    let queryResults: SeasonQueryResults
}

struct SeasonQueryResults: Codable {
    let row: SeasonRow
}

struct SeasonRow: Codable {
    let avg: String?
    let ops: String?
    let ab: String?
    let g: String?
    let r: String?
    let h: String?
    let hr: String?
    let rbi: String?
    let sb: String?
    let obp: String?
    let slg: String?
    let bb: String?
}

