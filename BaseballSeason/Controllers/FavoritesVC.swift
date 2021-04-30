//
//  FavoritesVC.swift
//  BaseballSeason
//
//  Created by Jon E on 4/13/21.
//

import UIKit

class FavoritesVC: UIViewController {
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name(NotificationName.reloadFavoriteTable), object: nil)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favorites"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .tertiarySystemBackground
        tableView.separatorStyle = .none
    }
    
    @objc func reloadData() {
        self.tableView.reloadData()
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerNetworkManager.shared.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        let name = PlayerNetworkManager.shared.favorites[indexPath.row].name
        let team = PlayerNetworkManager.shared.favorites[indexPath.row].teamName
        cell.backgroundColor = getTeamInfo(teamName: team).color
        cell.set(playerName: name, playerTeam: team)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerInfoVC()
        vc.playerName = PlayerNetworkManager.shared.favorites[indexPath.row].name
        vc.playerID = PlayerNetworkManager.shared.favorites[indexPath.row].playerID
        vc.playerTeam = PlayerNetworkManager.shared.favorites[indexPath.row].teamName
        
        if PlayerNetworkManager.shared.favorites[indexPath.row].isPitcher {
            vc.statType = .pitching
        } else {
            vc.statType = .hitting
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.bounds.height * 0.08
    }
}
