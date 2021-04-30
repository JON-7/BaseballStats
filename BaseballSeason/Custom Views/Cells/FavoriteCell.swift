//
//  FavoriteCell.swift
//  BaseballSeason
//
//  Created by Jon E on 4/28/21.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let reuseID = "favoriteID"
    
    let nameLabel = UILabel()
    let logo = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLogo()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLogo() {
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
         NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            logo.widthAnchor.constraint(equalToConstant: self.bounds.height),
            logo.heightAnchor.constraint(equalToConstant: self.bounds.height),
            logo.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 7),
        ])
    }
    
    func set(playerName: String, playerTeam: String) {
        nameLabel.text = playerName
        let image = getTeamInfo(teamName: playerTeam).logo
        logo.image = image
    }
}
