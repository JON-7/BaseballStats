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
    var alWildCardStandings = [DivisionStanding]()
    
    var nlEastStandings = [DivisionStanding]()
    var nlCentralStandings = [DivisionStanding]()
    var nlWestStandings = [DivisionStanding]()
    var nlWildCardStandings = [DivisionStanding]()
    
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
                NetworkLayer.request(endpoint: TeamInfoEndpoint.getStandings(division: division)) { [weak self] (result: Result<Teams, ErrorMessage>) in
                    switch result {
                    case .success(let data):
                        let standings = TeamNetworkManager.shared.getDivisionStandings(data: data)
                        switch division {
                        case Division.alEast:
                            self?.alEastStandings = standings
                        case Division.alCentral:
                            self?.alCentralStandings = standings
                        case Division.alWest:
                            self?.alWestStandings = standings
                        case Division.nlEast:
                            self?.nlEastStandings = standings
                        case Division.nlCentral:
                            self?.nlCentralStandings = standings
                        case Division.nlWest:
                            self?.nlWestStandings = standings
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
            self.alWildCardStandings = self.setWildCardStandings(for: League.al)
            self.nlWildCardStandings = self.setWildCardStandings(for: League.nl)
            self.configureCollectionView()
            self.removeSpinner()
        }
    }
    
    func setWildCardStandings(for league: String) -> [DivisionStanding] {
        var leagueStandings = [DivisionStanding]()
        var allWildcardTeams = [DivisionStanding]()
        var topWildCardTeams = [DivisionStanding]()
        
        if league == League.al {
            leagueStandings = alEastStandings + alCentralStandings + alWestStandings
        } else {
            leagueStandings = nlEastStandings + nlCentralStandings + nlWestStandings
        }
        
        for team in leagueStandings {
            if team.position != 1 {
                allWildcardTeams.append(team)
            }
        }
        
        let sortedStandings = allWildcardTeams.sorted { $0.winPercentage < $1.winPercentage}
        for n in 0..<5 {
            topWildCardTeams.append(sortedStandings[n])
        }
        return topWildCardTeams
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
                displayErrorMessage(error: .noFavorites)
            }
        }
    } 
}

extension TeamStandingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6 cells in each vertical group and there are 3 horizontal groups
        return 24
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // AL and NL sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TeamInfoVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
        let alDivisions = [alEastStandings, alCentralStandings, alWestStandings, alWildCardStandings]
        let nlDivisions = [nlEastStandings, nlCentralStandings, nlWestStandings, nlWildCardStandings]
        
        for n in 1...23 {
            let standingIndex = TeamNetworkManager.shared.getTeamStandingIndex(currentIndex: n)
            let divisionIndex = TeamNetworkManager.shared.getDivisionIndex(currentIndex: n)
            
            switch indexPath.item {
            case 6,12,18:
                break
            case n:
                if indexPath.section == 0 {
                    vc.teamName = alDivisions[divisionIndex][standingIndex].name
                    vc.teamID = alDivisions[divisionIndex][standingIndex].teamID
                } else {
                    vc.teamName = nlDivisions[divisionIndex][standingIndex].name
                    vc.teamID = nlDivisions[divisionIndex][standingIndex].teamID
                }
            default:
                break
            }
        }
    }
}
