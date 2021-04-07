//
//  Constants.swift
//  BaseballSeason
//
//  Created by Jon E on 4/1/21.
//

import UIKit

enum Division {
    static let alEast = "AL EAST"
    static let alCentral = "AL Central"
    static let alWest = "AL West"
    static let nlEast = "NL East"
    static let nlCentral = "NL Central"
    static let nlWest = "NL West"
}

// MARK: Returns the teams primary color and their logo
func getLogoAndColor(teamName: String) -> (color: UIColor, logo: UIImage?) {
    switch teamName {
    case "Toronto Blue Jays":
        return (#colorLiteral(red: 0.04107236117, green: 0.172498405, blue: 0.3624488115, alpha: 1), UIImage(named: "Toronto_Blue_Jays"))
    case "Tampa Bay Rays":
        return (#colorLiteral(red: 0.04107236117, green: 0.172498405, blue: 0.3624488115, alpha: 1), UIImage(named: "TampaBay_Rays"))
    case "Detroit Tigers":
            return (#colorLiteral(red: 0.979693234, green: 0.2728621066, blue: 0.08760742098, alpha: 1), UIImage(named: "Detroit_Tigers"))
    case "Chicago White Sox":
            return (#colorLiteral(red: 0.1532143652, green: 0.1434648931, blue: 0.1235511228, alpha: 1), UIImage(named: "Chicago_White_Sox"))
    case "Los Angeles Angels":
            return (#colorLiteral(red: 0.7278917432, green: 3.688367315e-06, blue: 0.1286149025, alpha: 1), UIImage(named: "LosAngeles_Angels"))
    case "Kansas City Royals":
            return (#colorLiteral(red: 0.002966023749, green: 0.2728747129, blue: 0.530271709, alpha: 1), UIImage(named: "KansasCity_Royals"))
    case "Baltimore Orioles":
            return (#colorLiteral(red: 0.873175323, green: 0.2728617787, blue: 0.01284751575, alpha: 1), UIImage(named: "Baltimore_Orioles"))
    case "New York Yankees":
            return (#colorLiteral(red: 0.08745852858, green: 0.1434698105, blue: 0.2728093863, alpha: 1), UIImage(named: "NewYork_Yankees"))
    case "Cleveland Indians":
            return (#colorLiteral(red: 0.06038464606, green: 0.1335850358, blue: 0.2417345047, alpha: 1), UIImage(named: "Cleveland_Indians"))
    case "Texas Rangers":
            return (#colorLiteral(red: 0.003062363248, green: 0.196067512, blue: 0.4717504978, alpha: 1), UIImage(named: "Texas_Rangers"))
    case "Seattle Mariners":
            return (#colorLiteral(red: 0.04915461689, green: 0.1385412514, blue: 0.2506843507, alpha: 1), UIImage(named: "Seattle_Mariners"))
    case "Boston Red Sox":
            return (#colorLiteral(red: 0.785253942, green: 0.06043253094, blue: 0.1819806397, alpha: 1), UIImage(named: "Boston_Redsox"))
    case "Minnesota Twins":
            return (#colorLiteral(red: 0.0491546616, green: 0.13854146, blue: 0.2551372647, alpha: 1), UIImage(named: "Minnesota_Twins"))
    case "Houston Astros":
            return (#colorLiteral(red: 0.003079404356, green: 0.1772542894, blue: 0.38313362, alpha: 1), UIImage(named: "Houston_Astros"))
    case "Oakland Athletics":
            return (#colorLiteral(red: 0.003033355111, green: 0.2191335559, blue: 0.1913406253, alpha: 1), UIImage(named: "Oakland_Athletics"))
    case "Milwaukee Brewers":
            return (#colorLiteral(red: 0.07676935941, green: 0.1629177332, blue: 0.2946044803, alpha: 1), UIImage(named: "Milwaukee_Brewers"))
    case "Philadelphia Phillies":
            return (#colorLiteral(red: 0.7278911471, green: 0.0492125228, blue: 0.1819741726, alpha: 1), UIImage(named: "Philadelphia_Phillies"))
    case "Pittsburgh Pirates":
            return (#colorLiteral(red: 0.06593046337, green: 0.06594686955, blue: 0.06592688709, alpha: 1), UIImage(named: "Pittsburgh_Pirates"))
    case "St.Louis Cardinals", "St. Louis Cardinals":
            return (#colorLiteral(red: 0.7278911471, green: 0.0492125228, blue: 0.1819741726, alpha: 1), UIImage(named: "StLouis_Cardinals"))
    case "San Diego Padres":
            return (#colorLiteral(red: 0.003079404356, green: 0.1772542894, blue: 0.38313362, alpha: 1), UIImage(named: "SanDiego_Padres"))
    case "Atlanta Braves":
            return (#colorLiteral(red: 0.003095555119, green: 0.158095628, blue: 0.3330959082, alpha: 1), UIImage(named: "Atlanta_Braves"))
    case "Arizona Diamondbacks":
            return (#colorLiteral(red: 0.6548262835, green: 0.09799856693, blue: 0.1866773963, alpha: 1), UIImage(named: "Arizona_Diamondbacks"))
    case "Washington Nationals":
            return (#colorLiteral(red: 0.7278906703, green: 0.07141274959, blue: 0.1677138805, alpha: 1), UIImage(named: "Washington_Nationals"))
    case "Chicago Cubs":
            return (#colorLiteral(red: 0.003075566376, green: 0.1819896698, blue: 0.4238680005, alpha: 1), UIImage(named: "Chicago_Cubs"))
    case "Los Angeles Dodgers":
            return (#colorLiteral(red: 0.07667429, green: 0.2903390229, blue: 0.5571314692, alpha: 1), UIImage(named: "LosAngeles_Dodgers"))
    case "Colorado Rockies":
            return (#colorLiteral(red: 0.2006739676, green: 0.2007154822, blue: 0.3995259404, alpha: 1), UIImage(named: "Colorado_Rockies"))
    case "New York Mets":
            return (#colorLiteral(red: 0.003080449766, green: 0.1772583127, blue: 0.4479368925, alpha: 1), UIImage(named: "NewYork_Mets"))
    case "Miami Marlins":
            return (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), UIImage(named: "Miami_Marlins"))
    case "Cincinnati Reds":
            return (#colorLiteral(red: 0.8347355723, green: 8.444653758e-06, blue: 0.1960567832, alpha: 1), UIImage(named: "Cincinnati_Reds"))
    case "San Francisco Giants":
            return (#colorLiteral(red: 0.979693234, green: 0.2728621066, blue: 0.08760742098, alpha: 1), UIImage(named: "SanFrancisco_Giants"))
    default:
            return (#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), UIImage(systemName: "person.3.fill"))
    }
}

enum StatType {
    case hitting
    case pitching
}


enum Stats {
    case avg
    case sb
    case hr
    case rbi
    case hits
    
    case era
    case wins
    case saves
    case so
    case whip
}

enum StatTitle {
    static let avg = "Average"
    static let sb = "Stolen Bases"
    static let hrs = "Home Runs"
    static let rbi = "RBI's"
    static let hits = "Hits"
    
    static let era = "ERA"
    static let wins = "Wins"
    static let saves = "Saves"
    static let so = "Strikeouts"
    static let whip = "Whip"
}

enum SegmentView {
    static let standings = "Standings"
    static let leaders = "Leaders"
    static let favorites = "Favorites"
}
