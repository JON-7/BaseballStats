//
//  LeagueLeadersVC.swift
//  BaseballSeason
//
//  Created by Jon E on 4/3/21.
//

import UIKit

class LeagueLeadersVC: UIViewController {
    
    weak var collectionView: UICollectionView!
    
    var hitsLeaders = [LeagueLeaders]()
    var hitsLeadersMain = [LeagueLeaders]()
    var hrLeaders = [LeagueLeaders]()
    var hrLeadersMain = [LeagueLeaders]()
    var avgLeaders = [LeagueLeaders]()
    var avgLeadersMain = [LeagueLeaders]()
    var sbLeaders = [LeagueLeaders]()
    var sbLeadersMain = [LeagueLeaders]()
    var rbiLeaders = [LeagueLeaders]()
    var rbiLeadersMain = [LeagueLeaders]()
    
    var soLeaders = [LeagueLeaders]()
    var soLeadersMain = [LeagueLeaders]()
    var winLeaders = [LeagueLeaders]()
    var winLeadersMain = [LeagueLeaders]()
    var svLeaders = [LeagueLeaders]()
    var svLeadersMain = [LeagueLeaders]()
    var eraLeaders = [LeagueLeaders]()
    var eraLeadersMain = [LeagueLeaders]()
    var whipLeaders = [LeagueLeaders]()
    var whipLeadersMain = [LeagueLeaders]()
    
    let leaderCell = LeadersCollectionCell()
    var segmentedControl = UISegmentedControl(items: ["MLB","AL","NL"])
    
    var isFavorite = false
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = 0
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    
    func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        cv.frame = view.bounds
        view.addSubview(cv)
    
        self.collectionView = cv
        collectionView.backgroundColor = .lightGray
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(LeadersCollectionCell.self, forCellWithReuseIdentifier: LeadersCollectionCell.reuseID)
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(viewDidChange), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        ])
    }
    
    @objc func viewDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async {
                self.hrLeaders = self.hrLeadersMain
                self.avgLeaders = self.avgLeadersMain
                self.rbiLeaders = self.rbiLeadersMain
                self.sbLeaders = self.sbLeadersMain
                self.hitsLeaders = self.hitsLeadersMain
                
                self.winLeaders = self.winLeadersMain
                self.eraLeaders = self.eraLeadersMain
                self.svLeaders = self.svLeadersMain
                self.soLeaders = self.soLeadersMain
                self.collectionView.reloadData()
            }
        case 1:
            setLeaders(for: "AL")
        case 2:
            setLeaders(for: "NL")
        default:
            break
        }
    }
    
    private func setLeaders(for league: String) {
        DispatchQueue.main.async {
            self.hrLeaders = self.getLeagueLeaders(leagueLeaders: self.hrLeaders, for: league)
            self.avgLeaders = self.getLeagueLeaders(leagueLeaders: self.avgLeaders, for: league)
            self.rbiLeaders = self.getLeagueLeaders(leagueLeaders: self.rbiLeaders, for: league)
            self.sbLeaders = self.getLeagueLeaders(leagueLeaders: self.sbLeaders, for: league)
            self.hitsLeaders = self.getLeagueLeaders(leagueLeaders: self.hitsLeaders, for: league)
            
            self.winLeaders = self.getLeagueLeaders(leagueLeaders: self.winLeaders, for: league)
            self.eraLeaders = self.getLeagueLeaders(leagueLeaders: self.eraLeaders, for: league)
            self.svLeaders = self.getLeagueLeaders(leagueLeaders: self.svLeaders, for: league)
            self.soLeaders = self.getLeagueLeaders(leagueLeaders: self.soLeaders, for: league)
            self.whipLeaders = self.getLeagueLeaders(leagueLeaders: self.whipLeaders, for: league)
            self.collectionView.reloadData()
        }
        self.hrLeaders = self.hrLeadersMain
        self.avgLeaders = self.avgLeadersMain
        self.rbiLeaders = self.rbiLeadersMain
        self.sbLeaders = self.sbLeadersMain
        self.hitsLeaders = self.hitsLeadersMain
        
        self.winLeaders = self.winLeadersMain
        self.eraLeaders = self.eraLeadersMain
        self.svLeaders = self.svLeadersMain
        self.soLeaders = self.soLeadersMain
        self.whipLeaders = self.whipLeadersMain
    }
    
    
    private func getLeagueLeaders(leagueLeaders: [LeagueLeaders], for league: String) -> [LeagueLeaders]{
        var leaders = [LeagueLeaders]()
        // 
        for n in 0..<leagueLeaders.count {
            if leagueLeaders[n].league == league {
                leaders.append(leagueLeaders[n])
            }
        }
        return leaders
    }
        
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        
        let hittingStats = [Stats.hr, Stats.avg, Stats.hits, Stats.rbi, Stats.sb]
        let pitchingStats = [Stats.wins, Stats.era, Stats.saves, Stats.so, Stats.whip]
        let allStats = hittingStats + pitchingStats
        
        DispatchQueue.main.async {
            // showing a spinner until the network call is complete and ui is updated
            self.showSpinner()
        }
        
        for stat in allStats {
            DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
                dispatchGroup.enter()
                
                // var that keeps track of the current stat type
                // needed bc the url is different depending on stat type
                var hittingOrPitching: StatType!
                
                if hittingStats.contains(stat) {
                    hittingOrPitching = .hitting
                } else {
                    hittingOrPitching = .pitching
                }
                
                PlayerNetworkManager.shared.getLeagueLeaders(for: stat, statType: hittingOrPitching) { [weak self] result in
                    switch result {
                    case .success(let data):
                        // data is an array of league leaders
                        switch stat {
                        case .avg:
                            self?.avgLeaders = data
                            self?.avgLeadersMain = data
                        case .sb:
                            self?.sbLeaders = data
                            self?.sbLeadersMain = data
                        case .hr:
                            self?.hrLeaders = data
                            self?.hrLeadersMain = data
                        case .rbi:
                            self?.rbiLeaders = data
                            self?.rbiLeadersMain = data
                        case .hits:
                            self?.hitsLeaders = data
                            self?.hitsLeadersMain = data
                        case .era:
                            self?.eraLeaders = data
                            self?.eraLeadersMain = data
                        case .wins:
                            self?.winLeaders = data
                            self?.winLeadersMain = data
                        case .saves:
                            self?.svLeaders = data
                            self?.svLeadersMain = data
                        case .so:
                            self?.soLeaders = data
                            self?.soLeadersMain = data
                        case .whip:
                            self?.whipLeaders = data
                            self?.whipLeadersMain = data
                        }
                    case .failure(let error):
                        // TODO: Add alert action displaying error
                        print(error)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.configureCollectionView()
            self.configureSegmentedControl()
            self.removeSpinner()
        }
    }
}


extension LeagueLeadersVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // cellForItemAt located in extension folder
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6 cells in the vertical group and 5 groups in total
        return 30
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Hitting and pitching sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerInfoVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)

        if indexPath.section == 0 {
            vc.statType = .hitting
            vc.isPitcher = false
            for n in 1...5 {
                if indexPath.item == n {
                    vc.playerName = hrLeaders[n-1].name
                    vc.playerID = hrLeaders[n-1].playerID
                }
            }

            for n in 7...11 {
                if indexPath.item == n {
                    vc.playerName = hitsLeaders[n-7].name
                    vc.playerID = hitsLeaders[n-7].playerID
                }
            }

            for n in 13...17 {
                if indexPath.item == n {
                    vc.playerName = avgLeaders[n-13].name
                    vc.playerID = avgLeaders[n-13].playerID
                }
            }

            for n in 19...23 {
                if indexPath.item == n {
                    vc.playerName = sbLeaders[n-19].name
                    vc.playerID = sbLeaders[n-19].playerID
                }
            }

            for n in 25...29 {
                if indexPath.item == n {
                    vc.playerName = rbiLeaders[n-25].name
                    vc.playerID = rbiLeaders[n-25].playerID
                }
            }
        }

        if indexPath.section == 1 {
            vc.isPitcher = true
            vc.statType = .pitching
            for n in 1...5 {
                if indexPath.item == n {
                    vc.playerName = winLeaders[n-1].name
                    vc.playerID = winLeaders[n-1].playerID
                }
            }

            for n in 7...11 {
                if indexPath.item == n {
                    vc.playerName = eraLeaders[n-7].name
                    vc.playerID = eraLeaders[n-7].playerID
                }
            }

            for n in 13...17 {
                if indexPath.item == n {
                    vc.playerName = soLeaders[n-13].name
                    vc.playerID = soLeaders[n-13].playerID
                }
            }

            for n in 19...23 {
                if indexPath.item == n {
                    vc.playerName = svLeaders[n-19].name
                    vc.playerID = svLeaders[n-19].playerID
                }
            }

            for n in 25...29 {
                if indexPath.item == n {
                    vc.playerName = whipLeaders[n-25].name
                    vc.playerID = whipLeaders[n-25].playerID
                }
            }
        }
    }
}
