//
//  LeadersCollectionCell.swift
//  BaseballSeason
//
//  Created by Jon E on 4/3/21.
//

import UIKit


class LeadersCollectionCell: UICollectionViewCell {
    
    static let reuseID = "leadersCell"

    let statView = LeagueLeadersView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStatName(statName: String) {
        statView.nameLabel.text = statName
        statView.statLabel.text = nil
        statView.logo.image = nil
        statView.backgroundColor = .secondarySystemFill
    }
    
    func configureMain(leaders: LeagueLeaders) {
        statView.nameLabel.text = leaders.name
        statView.statLabel.text = leaders.stat
        statView.logo.image = getLogoAndColor(teamName: leaders.teamName).logo
        statView.backgroundColor = getLogoAndColor(teamName: leaders.teamName).color
    }
    
    private func configureCell() {
        addSubview(statView)
        statView.frame = self.bounds
    }
}
