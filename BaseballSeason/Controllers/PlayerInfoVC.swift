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
    var playerTeam: String!
    var isPitcher: Bool!
    var playerSeasonStats: PlayerStats?
    var playerCareerStats: PlayerStats?
    var statType: StatType!
    
    let playerIntroView = PlayerIntroView()
    let seasonStatsView = PlayerStatsView(groupName: "Season Stats")
    let careerStatsView = PlayerStatsView(groupName: "Career Stats")
    let padding = CGFloat(20)
    var isFavorite = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getPlayerIntro()
        getFavoriteStatus()
    }
    
    private func configureView() {
        view.backgroundColor = getTeamInfo(teamName: playerTeam).color
        self.navigationController?.interactivePopGestureRecognizer?.delegate = .none
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFavoriteStatus() {
        // checking to see if the current player is a favorite player
        if !PlayerNetworkManager.shared.favorites.isEmpty {
            for n in 0..<PlayerNetworkManager.shared.favorites.count {
                if PlayerNetworkManager.shared.favorites[n].playerID == playerID {
                    isFavorite = true
                }
            }
        }
        // if the player is in the favorite list show a full star, if not show an empty star
        if isFavorite {
            navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: SFName.fullStar), style: .plain, target: self, action: #selector(changeFavoriteStatus))
        } else {
            navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: SFName.star), style: .plain, target: self, action: #selector(changeFavoriteStatus))
        }
    }
    
    @objc func changeFavoriteStatus() {
        var deleteIndex = -1
        
        // removing the player from the favorites list
        if isFavorite {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: SFName.star), style: .plain, target: self, action: #selector(self.changeFavoriteStatus))
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
                NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadFavoriteTable), object: nil)
            }
            isFavorite = false
            saveUserDefaults()
            
        } else {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: SFName.fullStar), style: .plain, target: self, action: #selector(self.changeFavoriteStatus))
            }
            
            let player = FavoritePlayers(name: playerName, playerID: playerID, isPitcher: isPitcher, teamName: playerTeam)
            PlayerNetworkManager.shared.favorites.append(player)
            saveUserDefaults()
            
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reloadFavoriteTable), object: nil)
            self.isFavorite = true
        }
    }
    
    func saveUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(PlayerNetworkManager.shared.favorites)
            UserDefaults.standard.set(data, forKey: KeyName.favoritePlayer)
        } catch {
            displayErrorMessage(error: ErrorMessage.addingFavFailed)
        }
    }
    
    func getPlayerIntro() {
        let group = DispatchGroup()
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        group.enter()
        DispatchQueue.global(qos: .background).async(group: group) {
            NetworkLayer.request(endpoint: PlayerInfoEndpoint.getPlayerInfo(playerName: self.playerName)) { [weak self] (result: Result<PlayerInfoResponse, ErrorMessage>) in
                switch result {
                case .success(let data):
                    self?.playerIntro = PlayerNetworkManager.shared.getPlayerInfo(for: data)
                case .failure(let error):
                    self?.removeSpinner()
                    self?.displayErrorMessage(error: error)
                }
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global(qos: .background).async(group: group) {
            if self.statType == .hitting {
                NetworkLayer.request(endpoint: PlayerInfoEndpoint.getPlayerSeasonStats(playerID: self.playerID, statType: self.statType)) { [weak self] (result: Result<HittingStats, ErrorMessage>) in
                    switch result {
                    case .success(let data):
                        self?.playerSeasonStats = PlayerNetworkManager.shared.getSeasonHittingStats(data: data)
                    case .failure(let error):
                        self?.removeSpinner()
                        self?.displayErrorMessage(error: error)
                    }
                    group.leave()
                }
            } else {
                NetworkLayer.request(endpoint: PlayerInfoEndpoint.getPlayerSeasonStats(playerID: self.playerID, statType: self.statType)) { [weak self] (result: Result<PitchingStats, ErrorMessage>) in
                    switch result {
                    case .success(let data):
                        self?.playerSeasonStats = PlayerNetworkManager.shared.getSeasonPitchingStats(data: data)
                    case .failure(let error):
                        self?.removeSpinner()
                        self?.displayErrorMessage(error: error)
                    }
                    group.leave()
                }
            }
        }
        group.enter()
        DispatchQueue.global(qos: .background).async(group: group) {
            if self.statType == .hitting {
                NetworkLayer.request(endpoint: PlayerInfoEndpoint.getPlayerCareerStats(playerID: self.playerID, statType: self.statType)) { [weak self] (result: Result<CareerHittingStats, ErrorMessage>) in
                    switch result {
                    case .success(let data):
                        self?.playerCareerStats = PlayerNetworkManager.shared.getCareerHittingStats(data: data)
                    case .failure(let error):
                        self?.removeSpinner()
                        self?.displayErrorMessage(error: error)
                    }
                    group.leave()
                }
            } else {
                NetworkLayer.request(endpoint: PlayerInfoEndpoint.getPlayerCareerStats(playerID: self.playerID, statType: self.statType)) { [weak self] (result: Result<CareerPitchingStats, ErrorMessage>) in
                    switch result {
                    case .success(let data):
                        self?.playerCareerStats = PlayerNetworkManager.shared.getCareerPitchingStats(data: data)
                    case .failure(let error):
                        self?.removeSpinner()
                        self?.displayErrorMessage(error: error)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.configurePlayerInfo()
            self.configureSeasonStats()
            self.configureCareerStats()
            self.removeSpinner()
        }
    }
    
    private func configurePlayerInfo() {
        let navBarHeight = CGFloat(navigationController?.navigationBar.bounds.height ?? 25)
        view.addSubview(playerIntroView)
        playerIntroView.translatesAutoresizingMaskIntoConstraints = false
        playerIntroView.set(playerInfo: playerIntro, topPadding: navBarHeight)
        
        NSLayoutConstraint.activate([
            playerIntroView.topAnchor.constraint(equalTo: view.topAnchor),
            playerIntroView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerIntroView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerIntroView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.35)
        ])
    }
    
    private func configureSeasonStats() {
        view.addSubview(seasonStatsView)
        seasonStatsView.translatesAutoresizingMaskIntoConstraints = false
        
        let emptyStats = PlayerStats(stat1: "", stat2: "", stat3: "", stat4: "", stat5: "", stat6: "", stat7: "", stat8: "", stat9: "", stat10: "", stat11: "", stat12: "")
        
        if statType == .hitting {
            seasonStatsView.setHittingStats(stats: playerSeasonStats ?? emptyStats)
        } else {
            seasonStatsView.setPitchingStats(stats: playerSeasonStats ?? emptyStats)
        }
        
        NSLayoutConstraint.activate([
            seasonStatsView.topAnchor.constraint(equalTo: playerIntroView.bottomAnchor, constant: 40),
            seasonStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            seasonStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureCareerStats() {
        let emptyStats = PlayerStats(stat1: "", stat2: "", stat3: "", stat4: "", stat5: "", stat6: "", stat7: "", stat8: "", stat9: "", stat10: "", stat11: "", stat12: "")
        
        view.addSubview(careerStatsView)
        careerStatsView.translatesAutoresizingMaskIntoConstraints = false
        if statType == .hitting {
            careerStatsView.setHittingStats(stats: playerCareerStats ?? emptyStats)
        } else {
            careerStatsView.setPitchingStats(stats: playerCareerStats ?? emptyStats)
        }
        
        NSLayoutConstraint.activate([
            careerStatsView.topAnchor.constraint(equalTo: seasonStatsView.bottomAnchor, constant: 235),
            careerStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            careerStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
}
