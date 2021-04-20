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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name(NotificationNames.reloadFavoriteTable), object: nil)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favorites"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
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
        let cell = UITableViewCell()
        
        cell.textLabel?.text = PlayerNetworkManager.shared.favorites[indexPath.row].name
        cell.backgroundColor = .lightGray
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerInfoVC()
        vc.playerName = PlayerNetworkManager.shared.favorites[indexPath.row].name
        vc.playerID = PlayerNetworkManager.shared.favorites[indexPath.row].playerID
        
        if PlayerNetworkManager.shared.favorites[indexPath.row].isPitcher {
            vc.statType = .pitching
        } else {
            vc.statType = .hitting
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
