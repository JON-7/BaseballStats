//
//  PlayerStatsView.swift
//  BaseballSeason
//
//  Created by Jon E on 4/6/21.
//

import UIKit

class PlayerStatsView: UIView {
    
    let typeLabel = UILabel()
    
    let stat1 = SingleStatView(statTitle: "AB")
    let stat2 = SingleStatView(statTitle: "G")
    let stat3 = SingleStatView(statTitle: "R")
    let stat4 = SingleStatView(statTitle: "H")
    let stat5 = SingleStatView(statTitle: "HR")
    let stat6 = SingleStatView(statTitle: "RBI")
    let stat7 = SingleStatView(statTitle: "SB")
    let stat8 = SingleStatView(statTitle: "AVG")
    let stat9 = SingleStatView(statTitle: "OBP")
    let stat10 = SingleStatView(statTitle: "OPS")
    let stat11 = SingleStatView(statTitle: "SLG")
    let stat12 = SingleStatView(statTitle: "BB")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStatType()
        configureFirstRow()
        configureSecondRow()
    }
    
    convenience init(typeOfGoal: String) {
        self.init(frame: .zero)
        typeLabel.text = typeOfGoal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStatType() {
        addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            typeLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func configureFirstRow() {
        let views = [stat1, stat2, stat3, stat4, stat5, stat6]
        
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: typeLabel.bottomAnchor),
                view.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 40)/6)
            ])
        }
        
        stat1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stat2.leadingAnchor.constraint(equalTo: stat1.trailingAnchor).isActive = true
        stat3.leadingAnchor.constraint(equalTo: stat2.trailingAnchor).isActive = true
        stat4.leadingAnchor.constraint(equalTo: stat3.trailingAnchor).isActive = true
        stat5.leadingAnchor.constraint(equalTo: stat4.trailingAnchor).isActive = true
        stat6.leadingAnchor.constraint(equalTo: stat5.trailingAnchor).isActive = true
        
        stat1.setTopLeftCornerRadius()
        stat6.setTopRightCornerRadius()
        stat7.setBottomLeftCornerRadius()
        stat12.setBottomRightCornerRadius()
    }
    
    func configureSecondRow() {
        let views = [stat7, stat8, stat9, stat10, stat11, stat12]
        
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: stat1.bottomAnchor, constant: 80),
                view.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 40)/6)
            ])
        }

        stat7.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stat8.leadingAnchor.constraint(equalTo: stat7.trailingAnchor).isActive = true
        stat9.leadingAnchor.constraint(equalTo: stat8.trailingAnchor).isActive = true
        stat10.leadingAnchor.constraint(equalTo: stat9.trailingAnchor).isActive = true
        stat11.leadingAnchor.constraint(equalTo: stat10.trailingAnchor).isActive = true
        stat12.leadingAnchor.constraint(equalTo: stat11.trailingAnchor).isActive = true
    }
}
