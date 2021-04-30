//
//  SingleStatView.swift
//  BaseballSeason
//
//  Created by Jon E on 4/6/21.
//

import UIKit

class SingleStatView: UIView {
    
    let statTitleLabel = UILabel()
    let statValueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(statTitle: String) {
        self.init(frame: .zero)
        statTitleLabel.text = statTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(statTitleLabel)
        statTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        statTitleLabel.backgroundColor = .systemBackground
        statTitleLabel.textAlignment = .center
        
        addSubview(statValueLabel)
        statValueLabel.translatesAutoresizingMaskIntoConstraints = false
        statValueLabel.backgroundColor = .tertiarySystemFill
        statValueLabel.textAlignment = .center
        statValueLabel.layer.borderWidth = 0.25
        
        NSLayoutConstraint.activate([
            statTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            statTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            statTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            statTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            statValueLabel.topAnchor.constraint(equalTo: statTitleLabel.bottomAnchor),
            statValueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            statValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            statValueLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setTopLeftCornerRadius() {
        statTitleLabel.clipsToBounds = true
        statTitleLabel.layer.cornerRadius = 16
        statTitleLabel.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func setTopRightCornerRadius() {
        statTitleLabel.clipsToBounds = true
        statTitleLabel.layer.cornerRadius = 16
        statTitleLabel.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    func setBottomLeftCornerRadius() {
        statValueLabel.clipsToBounds = true
        statValueLabel.layer.cornerRadius = 16
        statValueLabel.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    func setBottomRightCornerRadius() {
        statValueLabel.clipsToBounds = true
        statValueLabel.layer.cornerRadius = 16
        statValueLabel.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
}
