//
//  TeamInfoVC.swift
//  BaseballSeason
//
//  Created by Jon E on 4/11/21.
//

import UIKit

class TeamInfoVC: UIViewController {
    
    var collectionView: UICollectionView!
    var fullRoster: [RosterInfo]!
    var teamName: String!
    var teamID: Int!
    let nameLabel = UILabel()
    let logo = UIImageView()
    let rosterLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getRoster()
    }
    
    private func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .tertiarySystemBackground
    }
    
    private func getRoster() {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        let teamID = getTeamInfo(teamName: teamName).teamID
        
        DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
            dispatchGroup.enter()
            NetworkLayer.request(endpoint: TeamInfoEndpoint.getFullRoster(teamID: teamID)) { [weak self] (result: Result<RosterResponse, ErrorMessage>) in
                switch result {
                case .success(let data):
                    let roster = PlayerNetworkManager.shared.getTeamRoster(data: data)
                    self?.fullRoster = roster
                case .failure(let error):
                    self?.displayErrorMessage(error: error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.configureNameLabel()
            self.configureLogo()
            self.configureTeamRecord()
            self.configureCollectionView()
            self.removeSpinner()
        }
    }
    
    func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        nameLabel.text = teamName
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -60),
            nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func configureLogo() {
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = getTeamInfo(teamName: teamName).logo
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureTeamRecord() {
        view.addSubview(rosterLabel)
        rosterLabel.translatesAutoresizingMaskIntoConstraints = false
        rosterLabel.textAlignment = .left
        rosterLabel.font = .systemFont(ofSize: 30, weight: .bold)
        rosterLabel.text = "Roster"
        
        NSLayoutConstraint.activate([
            rosterLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10),
            rosterLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            rosterLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    // collectionView layout
    private func createCollectionFlowLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, evn -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets.bottom = 1
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
    private func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollectionFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cv)
        
        collectionView = cv
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RosterCell.self, forCellWithReuseIdentifier: RosterCell.reuseID)
        collectionView.backgroundColor = getTeamInfo(teamName: teamName).color
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: rosterLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}


extension TeamInfoVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullRoster.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RosterCell.reuseID, for: indexPath) as! RosterCell
        let total = fullRoster.count-1
        
        // configuring the corners of the first and last cell
        if indexPath.item == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            cell.set(playerName: fullRoster[0].lastNameFirstName, playerNumber: fullRoster[0].number, position: fullRoster[0].position)
        } else if indexPath.item == fullRoster.count-1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
            
            cell.set(playerName: fullRoster[total].lastNameFirstName, playerNumber: fullRoster[total].number, position: fullRoster[total].position)
        }
        
        // configuring the rest of the cells
        for n in 1..<total {
            if indexPath.item == n {
                cell.set(playerName: fullRoster[n].lastNameFirstName, playerNumber: fullRoster[n].number, position: fullRoster[n].position)
                cell.layer.cornerRadius = 0
            }
        }
        
        // setting the cell background color to be the same as the team color
        cell.backgroundColor = getTeamInfo(teamName: teamName).color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: When a cell is pressed the playerInfo screen is displayed
        for n in 0..<fullRoster.count {
            if indexPath.item == n {
                let vc = PlayerInfoVC()
                vc.playerID = fullRoster[n].playerID
                vc.playerName = fullRoster[n].name
                vc.playerTeam = teamName
                
                if fullRoster[n].position == "P" {
                    vc.statType = .pitching
                    vc.isPitcher = true
                } else {
                    vc.statType = .hitting
                    vc.isPitcher = false
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
