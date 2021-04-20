//
//  PlayerIntroView.swift
//  BaseballSeason
//
//  Created by Jon E on 4/5/21.
//

import UIKit

class PlayerIntroView: UIView {
    
    let nameLabel = UILabel()
    let line1Label = UILabel()
    let line2Label = UILabel()
    let line3Label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureNameLabel()
        configureSubText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textAlignment = .center
        nameLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    

    func configureSubText() {
        let views = [line1Label, line2Label, line3Label]
        
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textAlignment = .center
            view.font = .preferredFont(forTextStyle: .title3)
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
        }
        
        line1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        line2Label.topAnchor.constraint(equalTo: line1Label.bottomAnchor, constant: 10).isActive = true
        line3Label.topAnchor.constraint(equalTo: line2Label.bottomAnchor, constant: 10).isActive = true
        
        line2Label.numberOfLines = 0
        line2Label.lineBreakMode = .byWordWrapping
        line1Label.font = .systemFont(ofSize: 23, weight: .medium)
        line2Label.font = .systemFont(ofSize: 23, weight: .medium)
        line3Label.font = .systemFont(ofSize: 23, weight: .medium)
        
        line1Label.adjustsFontForContentSizeCategory = true
    }
    
    func set(playerInfo: PlayerIntro) {
        let birthDay = formatDate(stringDate: playerInfo.birthDate)
        let age = getPlayerAge(stringDate: playerInfo.birthDate)

        nameLabel.text = playerInfo.playerName
        line1Label.text = "Team: \(playerInfo.teamAbrv)    Position: \(playerInfo.position)    Age: \(age)"
                
        // If the player is not from the US, display home city instead of state
        if playerInfo.birthState == "" {
            line2Label.text = "Born: \(birthDay) in \(playerInfo.birthCity ), \(playerInfo.birthCountry)"
        } else {
            line2Label.text = "Born: \(birthDay) in \(playerInfo.birthState ), \(playerInfo.birthCountry)"
        }
        
        line3Label.text = "Height: \(playerInfo.heightFeet)'\(playerInfo.heightInches)    Weight: \(playerInfo.weight)"
    }
    
    func formatDate(stringDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = formatter.date(from: stringDate)
        return dateFormatter.string(from: date ?? Date())
    }
    
    func getPlayerAge(stringDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let date = formatter.date(from: stringDate) {
            let dateDiff = Calendar.current.dateComponents([.year], from: date, to: Date())
            return String(dateDiff.year!)
        } else {
            return "years ago"
        }
    }
}
