//
//  TeamStandingView.swift
//  BaseballSeason
//
//  Created by Jon E on 3/31/21.
//

import UIKit

class TeamStandingView: UIView {
    
    let logo = UIImageView()
    let teamNameLabel = UILabel()
    let teamRecord = UILabel()
    let gamesBehindLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLogo()
        configureName()
        configureRecord()
        configureGamesBehind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLogo() {
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
                
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            logo.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -250),
            logo.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func configureName() {
        addSubview(teamNameLabel)
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.font = .preferredFont(forTextStyle: .headline)
        teamNameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            teamNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            teamNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureRecord() {
        addSubview(teamRecord)
        teamRecord.translatesAutoresizingMaskIntoConstraints = false
        teamRecord.font = .systemFont(ofSize: 10, weight: .semibold)
        teamRecord.textAlignment = .right
        
        NSLayoutConstraint.activate([
            teamRecord.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -10),
            teamRecord.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
        ])
    }
    
    private func configureGamesBehind() {
        addSubview(gamesBehindLabel)
        gamesBehindLabel.translatesAutoresizingMaskIntoConstraints = false
        gamesBehindLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        gamesBehindLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            gamesBehindLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -10),
            gamesBehindLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10)
        ])
    }
}
