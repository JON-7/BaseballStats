//
//  TeamStandingsVC.swift
//  BaseballSeason
//
//  Created by Jon E on 3/30/21.
//

import UIKit

class TeamStandingsVC: UIViewController {
    
    var alEastStandings = [DivisionStanding]()
    var alCentralStandings = [DivisionStanding]()
    var alWestStandings = [DivisionStanding]()
    
    var nlEastStandings = [DivisionStanding]()
    var nlCentralStandings = [DivisionStanding]()
    var nlWestStandings = [DivisionStanding]()
    
    var segmentedControl = UISegmentedControl(items: ["Standings", "Leaders"])
    let leagueLeadersVC = LeagueLeadersVC()
    
    weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorites()
        getDivisionStandings()
    }
    
    func getDivisionStandings() {
        let dispatchGroup = DispatchGroup()
        let divisions = [Division.alEast, Division.alCentral, Division.alWest, Division.nlEast, Division.nlCentral, Division.nlWest]
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
        
        for division in divisions  {
            DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
                dispatchGroup.enter()
                TeamNetworkManager.shared.getStandings(for: division) { [weak self] result in
                    switch result {
                    case .success(let data):
                        // data is an array of divisionStandings
                        switch division {
                        case Division.alEast:
                            self?.alEastStandings = data
                        case Division.alCentral:
                            self?.alCentralStandings = data
                        case Division.alWest:
                            self?.alWestStandings = data
                        case Division.nlEast:
                            self?.nlEastStandings = data
                        case Division.nlCentral:
                            self?.nlCentralStandings = data
                        case Division.nlWest:
                            self?.nlWestStandings = data
                        default:
                            break
                        }
                    case .failure(let error):
                        self?.displayErrorMessage(error: error)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.configureCollectionView()
            self.removeSpinner()
        }
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(viewDidChange), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
        ])
    }
    
    @objc func viewDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            leagueLeadersVC.modalPresentationStyle = .fullScreen
            leagueLeadersVC.modalTransitionStyle = .crossDissolve
            navigationController?.pushViewController(leagueLeadersVC, animated: true)
        default:
            break
        }
    }
    
    func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        cv.frame = view.bounds
        view.addSubview(cv)
        
        collectionView = cv
        collectionView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StandingsCollectionCell.self, forCellWithReuseIdentifier: StandingsCollectionCell.reuseID)
        collectionView.isScrollEnabled = false
    }
    
    private func getFavorites() {
        if let data = UserDefaults.standard.object(forKey: KeyName.favoritePlayer) as? Data {
            do {
                let decoder = JSONDecoder()
                let storedPlayers = try decoder.decode([FavoritePlayers].self, from: data)
                PlayerNetworkManager.shared.favorites = storedPlayers
            } catch {
                print("Could not retrieve favorites")
            }
        }
    }
}

extension TeamStandingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6 cells in each vertical group and there are 3 horizontal groups
        return 18
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // AL and NL sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TeamInfoVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 1:
                vc.teamName = alEastStandings[0].name
                vc.teamID = alEastStandings[0].teamID
            case 2:
                vc.teamName = alEastStandings[1].name
                vc.teamID = alEastStandings[1].teamID
            case 3:
                vc.teamName = alEastStandings[2].name
                vc.teamID = alEastStandings[2].teamID
            case 4:
                vc.teamName = alEastStandings[3].name
                vc.teamID = alEastStandings[3].teamID
            case 5:
                vc.teamName = alEastStandings[4].name
                vc.teamID = alEastStandings[4].teamID
            case 7:
                vc.teamName = alCentralStandings[0].name
                vc.teamID = alCentralStandings[0].teamID
            case 8:
                vc.teamName = alCentralStandings[1].name
                vc.teamID = alCentralStandings[1].teamID
            case 9:
                vc.teamName = alCentralStandings[2].name
                vc.teamID = alCentralStandings[2].teamID
            case 10:
                vc.teamName = alCentralStandings[3].name
                vc.teamID = alCentralStandings[3].teamID
            case 11:
                vc.teamName = alCentralStandings[4].name
                vc.teamID = alCentralStandings[4].teamID
            case 13:
                vc.teamName = alWestStandings[0].name
                vc.teamID = alWestStandings[0].teamID
            case 14:
                vc.teamName = alWestStandings[1].name
                vc.teamID = alWestStandings[1].teamID
            case 15:
                vc.teamName = alWestStandings[2].name
                vc.teamID = alWestStandings[2].teamID
            case 16:
                vc.teamName = alWestStandings[3].name
                vc.teamID = alWestStandings[3].teamID
            case 17:
                vc.teamName = alWestStandings[4].name
                vc.teamID = alWestStandings[4].teamID
            default:
                break
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.item {
            case 1:
                vc.teamName = nlEastStandings[0].name
                vc.teamID = nlEastStandings[0].teamID
            case 2:
                vc.teamName = nlEastStandings[1].name
                vc.teamID = nlEastStandings[1].teamID
            case 3:
                vc.teamName = nlEastStandings[2].name
                vc.teamID = nlEastStandings[2].teamID
            case 4:
                vc.teamName = nlEastStandings[3].name
                vc.teamID = nlEastStandings[3].teamID
            case 5:
                vc.teamName = nlEastStandings[4].name
                vc.teamID = nlEastStandings[4].teamID
            case 7:
                vc.teamName = nlCentralStandings[0].name
                vc.teamID = nlCentralStandings[0].teamID
            case 8:
                vc.teamName = nlCentralStandings[1].name
                vc.teamID = nlCentralStandings[1].teamID
            case 9:
                vc.teamName = nlCentralStandings[2].name
                vc.teamID = nlCentralStandings[2].teamID
            case 10:
                vc.teamName = nlCentralStandings[3].name
                vc.teamID = nlCentralStandings[3].teamID
            case 11:
                vc.teamName = nlCentralStandings[4].name
                vc.teamID = nlCentralStandings[4].teamID
            case 13:
                vc.teamName = nlWestStandings[0].name
                vc.teamID = nlWestStandings[0].teamID
            case 14:
                vc.teamName = nlWestStandings[1].name
                vc.teamID = nlWestStandings[1].teamID
            case 15:
                vc.teamName = nlWestStandings[2].name
                vc.teamID = nlWestStandings[2].teamID
            case 16:
                vc.teamName = nlWestStandings[3].name
                vc.teamID = nlWestStandings[3].teamID
            case 17:
                vc.teamName = nlWestStandings[4].name
                vc.teamID = nlWestStandings[4].teamID
            default:
                break
            }
        }
    }
}
