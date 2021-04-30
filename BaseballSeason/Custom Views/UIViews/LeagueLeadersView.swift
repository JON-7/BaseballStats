//
//  LeagueLeadersView.swift
//  BaseballSeason
//
//  Created by Jon E on 4/3/21.
//

import UIKit

class LeagueLeadersView: UIView {
    
    let logo = UIImageView()
    let nameLabel = UILabel()
    let statLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLogo()
        configureNameLabel()
        configureStatLabel()
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
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureStatLabel() {
        addSubview(statLabel)
        statLabel.translatesAutoresizingMaskIntoConstraints = false
        statLabel.font = .boldSystemFont(ofSize: 30)
        
        NSLayoutConstraint.activate([
            statLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -10),
            statLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
