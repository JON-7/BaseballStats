//
//  PlayerStats.swift
//  BaseballSeason
//
//  Created by Jon E on 4/11/21.
//

import Foundation

struct PlayerStats {
    let stat1: String?
    let stat2: String?
    let stat3: String?
    let stat4: String?
    let stat5: String?
    let stat6: String?
    let stat7: String?
    let stat8: String?
    let stat9: String?
    let stat10: String?
    let stat11: String?
    let stat12: String?
}

//MARK: Season hitting stats
func getSeasonHittingStats(data: HittingStats?) -> PlayerStats {
    guard let hittingData = data else {
        return PlayerStats(stat1: "0", stat2: "0", stat3: "0", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: ".000", stat10: ".000", stat11: ".000", stat12: "0")
    }
    
    let results = hittingData.sportHittingTm.queryResults.row
    let hittingStats = PlayerStats(stat1: results.ab, stat2: results.g, stat3: results.r, stat4: results.h, stat5: results.hr, stat6: results.rbi, stat7: results.avg, stat8: results.sb, stat9: results.obp, stat10: results.ops, stat11: results.slg, stat12: results.bb)
    return hittingStats
}

//MARK: Season pitching stats
func getSeasonPitchingStats(data: PitchingStats?) -> PlayerStats {
    guard let pitchingData = data else {
        return PlayerStats(stat1: "0", stat2: "0", stat3: ".000", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: "0.00", stat10: "0", stat11: "0.00", stat12: "0.00")
    }
    
    let results = pitchingData.sportPitchingTm.queryResults.row
    let pitchingStats = PlayerStats(stat1: results.w, stat2: results.l, stat3: results.wpct, stat4: results.g, stat5: results.ip, stat6: results.sv, stat7: results.era, stat8: results.so, stat9: results.whip, stat10: results.bb, stat11: results.h9, stat12: results.hr9)
    return pitchingStats
}


func getCareerHittingStats(data: CareerHittingStats?) -> PlayerStats {
    guard let hittingData = data else {
        return PlayerStats(stat1: "0", stat2: "0", stat3: "0", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: ".000", stat10: ".000", stat11: ".000", stat12: "0")
    }
    
    let results = hittingData.sportCareerHitting.queryResults.row
    let hittingStats = PlayerStats(stat1: results.ab, stat2: results.g, stat3: results.r, stat4: results.h, stat5: results.hr, stat6: results.rbi, stat7: results.avg, stat8: results.sb, stat9: results.obp, stat10: results.ops, stat11: results.slg, stat12: results.bb)
    return hittingStats
}

func getCareerPitchingStats(data: CareerPitchingStats?) -> PlayerStats {
    guard let pitchingData = data else {
        return PlayerStats(stat1: "0", stat2: "0", stat3: ".000", stat4: "0", stat5: "0", stat6: "0", stat7: ".000", stat8: "0", stat9: "0.00", stat10: "0", stat11: "0.00", stat12: "0.00")
    }
    
    let results = pitchingData.sportCareerPitching.queryResults.row
    let pitchingStats = PlayerStats(stat1: results.w, stat2: results.l, stat3: results.wpct, stat4: results.g, stat5: results.ip, stat6: results.sv, stat7: results.era, stat8: results.so, stat9: results.whip, stat10: results.bb, stat11: results.h9, stat12: results.hr9)
    return pitchingStats
}

