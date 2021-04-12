//
//  RosterCell.swift
//  BaseballSeason
//
//  Created by Jon E on 4/11/21.
//

import UIKit

class RosterCell: UICollectionViewCell {
    static let reuseID = "rosterID"
    
    let nameLabel = UILabel()
    let playerNumber = UILabel()
    let positionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureNameLabel()
        configureNumber()
        configurePostionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configurePostionLabel() {
        addSubview(positionLabel)
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            positionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            positionLabel.trailingAnchor.constraint(equalTo: playerNumber.leadingAnchor,constant: -10),
            positionLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureNumber() {
        addSubview(playerNumber)
        playerNumber.translatesAutoresizingMaskIntoConstraints = false
        playerNumber.textAlignment = .center
        
        NSLayoutConstraint.activate([
            playerNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playerNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            playerNumber.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func set(playerName: String, playerNumber: String, position: String) {
        self.nameLabel.text = playerName
        self.playerNumber.text = "#\(playerNumber)"
        self.positionLabel.text = position
    }
}
