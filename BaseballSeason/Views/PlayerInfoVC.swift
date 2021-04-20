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
    var isPitcher: Bool!
    var playerSeasonStats: PlayerStats!
    var playerCareerStats: PlayerStats!
    var statType: StatType!
    
    let outerView = UIView()
    let playerIntroView = PlayerIntroView()
    let seasonStatsView = PlayerStatsView(groupName: "Season Stats")
    let careerStatsView = PlayerStatsView(groupName: " Career Stats")
    let padding = CGFloat(20)
    var isFavorite = false
    
    let userDefaults = UserDefaults()
    var numbers = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlayerIntro()
        view.backgroundColor = #colorLiteral(red: 0.1235559806, green: 0.1235806867, blue: 0.1434322894, alpha: 1)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        // checking to see if the current player is a favorite player
        if !PlayerNetworkManager.shared.favorites.isEmpty {
            for n in 0..<PlayerNetworkManager.shared.favorites.count {
                if PlayerNetworkManager.shared.favorites[n].playerID == playerID {
                    isFavorite = true
                }
            }
        }
        
        // if a favorite player show a full star, if not then show an empty star
        if isFavorite {
            navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(changeFavoriteStatus))
        } else {
            navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(changeFavoriteStatus))
        }
    }
    
    @objc func changeFavoriteStatus() {
        var deleteIndex = -1
        
        // removing the player from the favorites list
        if isFavorite {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.changeFavoriteStatus))
            }
            
            // finding the player index in the favorite array
            for n in 0..<PlayerNetworkManager.shared.favorites.count {
                if PlayerNetworkManager.shared.favorites[n].playerID == playerID {
                    deleteIndex = n
                }
            }
            // deleting from the favorite array
            if (deleteIndex >= 0) {
                PlayerNetworkManager.shared.favorites.remove(at: deleteIndex)
                NotificationCenter.default.post(name: Notification.Name("newDataNotif"), object: nil)
            }
            
            isFavorite = false
            
        } else {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(self.changeFavoriteStatus))
            }
            
            let player = FavoritePlayers(name: playerName, playerID: playerID, isPitcher: isPitcher)
            PlayerNetworkManager.shared.favorites.append(player)
            NotificationCenter.default.post(name: Notification.Name("newDataNotif"), object: nil)
            self.isFavorite = true
        }
    }
    
    func getPlayerIntro() {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            PlayerNetworkManager.shared.getPlayerInfo(playerName: self.playerName) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.playerIntro = data
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            PlayerNetworkManager.shared.getPlayerSeasonStats(playerID: self.playerID, statType: self.statType) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.playerSeasonStats = data
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            PlayerNetworkManager.shared.getPlayerCareerStats(playerID: self.playerID, statType: self.statType) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.playerCareerStats = data
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
            outerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.3)
        ])
        
        configurePlayerInfo()
    }
    
    private func configurePlayerInfo() {
        let navBarHeight = CGFloat(navigationController?.navigationBar.bounds.height ?? 25)
        outerView.addSubview(playerIntroView)
        playerIntroView.translatesAutoresizingMaskIntoConstraints = false
        playerIntroView.set(playerInfo: playerIntro)
        
        NSLayoutConstraint.activate([
            playerIntroView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight - 20),
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
