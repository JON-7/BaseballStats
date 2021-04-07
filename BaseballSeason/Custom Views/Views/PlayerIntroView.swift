//
//  PlayerIntroView.swift
//  BaseballSeason
//
//  Created by Jon E on 4/5/21.
//

import UIKit

// ADD height -> weight -> country

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
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
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
                view.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        line1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        line2Label.topAnchor.constraint(equalTo: line1Label.bottomAnchor).isActive = true
        line3Label.topAnchor.constraint(equalTo: line2Label.bottomAnchor).isActive = true
    }
    
    func set() {
        nameLabel.text = "Aaron Judge"
        line1Label.text = "Team: NYY  Position: RF  Age: 28"
        line2Label.text = "Born: 04/26/1992 in CA, USA"
        line3Label.text = "Height: 6'7  Weight: 282"
    }
    
}
