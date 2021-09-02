//
//  StandingsCollectionCell.swift
//  BaseballSeason
//
//  Created by Jon E on 3/31/21.
//

import UIKit

class StandingsCollectionCell: UICollectionViewCell {
    
    static let reuseID = "standingsCell"

    let teamView = TeamStandingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTeamView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTeamView() {
        addSubview(teamView)
        teamView.frame = self.bounds
    }
    
    func configureMainView(standings: [DivisionStanding], index: Int, isDivisionStanding: Bool) {
        teamView.teamNameLabel.text = standings[index].name
        teamView.logo.image = getTeamInfo(teamName: standings[index].name).logo
        teamView.backgroundColor = getTeamInfo(teamName: standings[index].name).color
        teamView.teamRecord.text = "\(standings[index].wins ) - \(standings[index].loses )"
        
        let gamesBehind = getGamesBehind(standings: standings, index: index, wildCard: false)

        
        if isDivisionStanding {
            if gamesBehind == 0 {
                teamView.gamesBehindLabel.text = "GB: -"
            } else {
                teamView.gamesBehindLabel.text = "GB: \(gamesBehind)"
            }
        } else {
            if index == 0 {
                teamView.gamesBehindLabel.text = "GB: +\(getGamesBehind(standings: standings, index: index+1, wildCard: false))"
            } else if index == 1 {
                teamView.gamesBehindLabel.text = "GB: -"
            } else {
                teamView.gamesBehindLabel.text = "GB: \(getGamesBehind(standings: standings, index: index, wildCard: true))"
            }
        }
    }
    
    func getGamesBehind(standings: [DivisionStanding], index: Int, wildCard: Bool) -> Double {
        let leadingDivisionWins = Double(standings[0].wins)
        let leadingDivisionLoses = Double(standings[0].loses)
        
        let secondPlaceWins = Double(standings[1].wins)
        let secondPlaceLoses = Double(standings[1].loses)
        
        let teamWins = Double(standings[index].wins)
        let teamLoses = Double(standings[index].loses)
        
        let wcDifference = ((secondPlaceWins - secondPlaceLoses) - (teamWins - teamLoses)) / 2
        let difference = (leadingDivisionWins - leadingDivisionLoses) - (teamWins - teamLoses)
        let gamesBehind = difference/2
        
        if wildCard {
            return wcDifference
        } else {
            return gamesBehind
        }
    }
    
    func configureDivisionTitle(division: String) {
        teamView.teamNameLabel.text = division
        teamView.logo.image = .none
        teamView.backgroundColor = .tertiarySystemGroupedBackground
        teamView.gamesBehindLabel.text = .none
        teamView.teamRecord.text = .none
    }
    
    func setTopCornerRadius() {
        teamView.layer.cornerRadius = 16
        teamView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        isUserInteractionEnabled = false
    }

    func setBottomCornerRadius() {
        teamView.layer.cornerRadius = 16
        teamView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
        isUserInteractionEnabled = true
    }

    func defaultCorner() {
        teamView.layer.cornerRadius = 0
        isUserInteractionEnabled = true
    }
}
