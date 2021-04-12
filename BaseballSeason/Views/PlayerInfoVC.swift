//
//  PlayerInfoVC.swift
//  BaseballSeason
//
//  Created by Jon E on 4/5/21.
//

import UIKit

class PlayerInfoVC: UIViewController {
    
    var playerIntro: PlayerIntro!
    var playerName: String!
    var playerID: String!
    var playerSeasonStats: PlayerStats!
    var playerCareerStats: PlayerStats!
    var statType: StatType!
    
    let outerView = UIView()
    let playerIntroView = PlayerIntroView()
    let seasonStatsView = PlayerStatsView(groupName: "Season Stats")
    let careerStatsView = PlayerStatsView(groupName: " Career Stats")
    let padding = CGFloat(20)
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlayerIntro()
        view.backgroundColor = #colorLiteral(red: 0.1235559806, green: 0.1235806867, blue: 0.1434322894, alpha: 1)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        configureOuter()
//        configureSeasonStats()
//        configureCareerStats()
    }
    
    func getPlayerIntro() {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            NetworkManager.shared.getPlayerInfo(playerName: self.playerName) { result in
                switch result {
                case .success(let data):
                    self.playerIntro = data
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            NetworkManager.shared.getPlayerSeasonStats(playerID: self.playerID, statType: self.statType) { result in
                switch result {
                case .success(let data):
                    self.playerSeasonStats = data
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            NetworkManager.shared.getPlayerCareerStats(playerID: self.playerID, statType: self.statType) { result in
                switch result {
                case .success(let data):
                    print(data)
                    self.playerCareerStats = data
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.configureOuter()
            self.configureSeasonStats()
            self.configureCareerStats()
            self.removeSpinner()
        }
    }
    
    func configureOuter() {
        view.addSubview(outerView)
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        outerView.backgroundColor = #colorLiteral(red: 0.2946154475, green: 0.2989868522, blue: 0.2946062088, alpha: 1)
        outerView.layer.cornerRadius = 16
        outerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 10
        
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: view.topAnchor),
            outerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outerView.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        configurePlayerInfo()
    }
    
    private func configurePlayerInfo() {
        outerView.addSubview(playerIntroView)
        playerIntroView.translatesAutoresizingMaskIntoConstraints = false
        playerIntroView.set(playerInfo: playerIntro)
        
        NSLayoutConstraint.activate([
            playerIntroView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 55),
            playerIntroView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor),
            playerIntroView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor)
        ])
    }
    
    private func configureSeasonStats() {
        view.addSubview(seasonStatsView)
        seasonStatsView.translatesAutoresizingMaskIntoConstraints = false
        if statType == .hitting {
            seasonStatsView.setHittingStats(stats: playerSeasonStats)
        } else {
            seasonStatsView.setPitchingStats(stats: playerSeasonStats)
        }
        
        NSLayoutConstraint.activate([
            seasonStatsView.topAnchor.constraint(equalTo: outerView.bottomAnchor, constant: 40),
            seasonStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            seasonStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureCareerStats() {
        view.addSubview(careerStatsView)
        careerStatsView.translatesAutoresizingMaskIntoConstraints = false
        if statType == .hitting {
            careerStatsView.setHittingStats(stats: playerCareerStats)
        } else {
            careerStatsView.setPitchingStats(stats: playerCareerStats)
        }
        
        NSLayoutConstraint.activate([
            careerStatsView.topAnchor.constraint(equalTo: seasonStatsView.bottomAnchor, constant: 235),
            careerStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            careerStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
}
