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
    
    func configureMainView(standings: [DivisionStanding], index: Int) {
        teamView.teamNameLabel.text = standings[index].name
        teamView.logo.image = getTeamInfo(teamName: standings[index].name).logo
        teamView.backgroundColor = getTeamInfo(teamName: standings[index].name).color
        teamView.teamRecord.text = "\(standings[index].wins ) - \(standings[index].loses )"
        
        let difference = (standings[0].wins - standings[0].loses) - (standings[index].wins - standings[index].loses)
        let gamesBehind: Double = Double(difference / 2)
        if gamesBehind == 0 {
            teamView.gamesBehindLabel.text = "GB: -"
        } else {
            teamView.gamesBehindLabel.text = "GB: \(gamesBehind)"
        }
    }
    
    func configureDivisionTitle(division: String) {
        teamView.teamNameLabel.text = division
        teamView.logo.image = .none
        teamView.backgroundColor = .tertiarySystemGroupedBackground
        teamView.gamesBehindLabel.text = .none
        teamView.teamRecord.text = .none
    }
}
