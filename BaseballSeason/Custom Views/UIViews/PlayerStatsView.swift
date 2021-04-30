//
//  PlayerStatsView.swift
//  BaseballSeason
//
//  Created by Jon E on 4/6/21.
//

import UIKit

class PlayerStatsView: UIView {
    
    let groupNameLabel = UILabel()
    var statType: StatType!
    
    let stat1 = SingleStatView()
    let stat2 = SingleStatView()
    let stat3 = SingleStatView()
    let stat4 = SingleStatView()
    let stat5 = SingleStatView()
    let stat6 = SingleStatView()
    let stat7 = SingleStatView()
    let stat8 = SingleStatView()
    let stat9 = SingleStatView()
    let stat10 = SingleStatView()
    let stat11 = SingleStatView()
    let stat12 = SingleStatView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStatType()
        configureFirstRow()
        configureSecondRow()
    }
    
    convenience init(groupName: String) {
        self.init(frame: .zero)
        groupNameLabel.text = groupName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStatType() {
        addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        
        NSLayoutConstraint.activate([
            groupNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            groupNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func configureFirstRow() {
        let views = [stat1, stat2, stat3, stat4, stat5, stat6]
        
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor),
                view.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 40)/6)
            ])
        }
        
        stat1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stat2.leadingAnchor.constraint(equalTo: stat1.trailingAnchor).isActive = true
        stat3.leadingAnchor.constraint(equalTo: stat2.trailingAnchor).isActive = true
        stat4.leadingAnchor.constraint(equalTo: stat3.trailingAnchor).isActive = true
        stat5.leadingAnchor.constraint(equalTo: stat4.trailingAnchor).isActive = true
        stat6.leadingAnchor.constraint(equalTo: stat5.trailingAnchor).isActive = true
        
        //setting corner radius of the top and bottom corners
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
    
    
    

    func setHittingStats(stats: PlayerStats) {
        let views = [stat1, stat2, stat3, stat4, stat5, stat6, stat7, stat8, stat9, stat10, stat11, stat12]
        
        let hittingTitles = ["AB", "G", "R", "H", "HR", "RBI", "AVG", "SB", "OBP", "OPS", "SLG", "BB"]
        
        var x = 0
        for view in views {
            view.statTitleLabel.text = hittingTitles[x]
            x += 1
        }
        
        stat1.statValueLabel.text = stats.stat1
        stat2.statValueLabel.text = stats.stat2
        stat3.statValueLabel.text = stats.stat3
        stat4.statValueLabel.text = stats.stat4
        stat5.statValueLabel.text = stats.stat5
        stat6.statValueLabel.text = stats.stat6
        stat7.statValueLabel.text = stats.stat7
        stat8.statValueLabel.text = stats.stat8
        stat9.statValueLabel.text = stats.stat9
        stat10.statValueLabel.text = stats.stat10
        stat11.statValueLabel.text = stats.stat11
        stat12.statValueLabel.text = stats.stat12
    }
    
    func setPitchingStats(stats: PlayerStats) {
        let views = [stat1, stat2, stat3, stat4, stat5, stat6, stat7, stat8, stat9, stat10, stat11, stat12]
        let pitchingTitles = ["W", "L", "W%", "G", "IP", "SV", "ERA", "SO", "WHIP", "BB", "H9", "HR9"]
        
        var x = 0
        for view in views {
            view.statTitleLabel.text = pitchingTitles[x]
            x += 1
        }
        
        stat1.statValueLabel.text = stats.stat1
        stat2.statValueLabel.text = stats.stat2
        stat3.statValueLabel.text = stats.stat3
        stat4.statValueLabel.text = stats.stat4
        stat5.statValueLabel.text = stats.stat5
        stat6.statValueLabel.text = stats.stat6
        stat7.statValueLabel.text = stats.stat7
        stat8.statValueLabel.text = stats.stat8
        stat9.statValueLabel.text = stats.stat9
        stat10.statValueLabel.text = stats.stat10
        stat11.statValueLabel.text = stats.stat11
        stat12.statValueLabel.text = stats.stat12
    }
}
