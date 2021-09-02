//
//  LeagueLeadersVC.swift
//  BaseballSeason
//
//  Created by Jon E on 4/3/21.
//

import UIKit

class LeagueLeadersVC: UIViewController {
    
    var hitLeaders = [LeagueLeaders]()
    var hitLeadersMain = [LeagueLeaders]()
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
    
    let group = DispatchGroup()
    weak var collectionView: UICollectionView!
    private let segmentedControl = UISegmentedControl(items: [League.mlb, League.al, League.nl])
    var isFavorite = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        DispatchQueue.main.async {
            self.showSpinner()
        }
        group.enter()
        DispatchQueue.global().async(group: group) {
            self.setAllLeagueLeaders()
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            self.configureCollectionView()
            self.configureSegmentedControl()
            self.removeSpinner()
        }
    }
    
    func getData(for stat: Stat, statType: StatType, completion: @escaping (Result<[LeagueLeaders], Error>) -> ()) {
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkLayer.request(endpoint: LeagueLeaderEndpoint.getLeagueLeaders(stat: stat, statType: statType)) { [weak self] (result: Result<LeadersResponse, ErrorMessage>) in
                switch result {
                case .success(let data):
                    let statLeaders = PlayerNetworkManager.shared.getLeagueLeaderArray(data: data, stat: stat, statType: statType)
                    completion(.success(statLeaders))
                    self?.group.leave()
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                    self?.group.leave()
                }
            }
        }
    }
    
    private func getStatLeaders(for stat: Stat) {
        var typeOfStat = StatType.pitching
        if stat == .hits || stat == .avg || stat == .hr || stat == .rbi || stat == .sb {
            typeOfStat = .hitting
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            self.getData(for: stat, statType: typeOfStat) { [weak self] res in
                switch res {
                case .success(let leaders):
                    switch stat {
                    case .avg:
                        self?.avgLeaders = leaders
                        self?.avgLeadersMain = leaders
                    case .sb:
                        self?.sbLeaders = leaders
                        self?.sbLeadersMain = leaders
                    case .hr:
                        self?.hrLeaders = leaders
                        self?.hrLeadersMain = leaders
                    case .rbi:
                        self?.rbiLeaders = leaders
                        self?.rbiLeadersMain = leaders
                    case .hits:
                        self?.hitLeaders = leaders
                        self?.hitLeadersMain = leaders
                    case .era:
                        self?.eraLeaders = leaders
                        self?.eraLeadersMain = leaders
                    case .wins:
                        self?.winLeaders = leaders
                        self?.winLeadersMain = leaders
                    case .sv:
                        self?.svLeaders = leaders
                        self?.svLeadersMain = leaders
                    case .so:
                        self?.soLeaders = leaders
                        self?.soLeadersMain = leaders
                    case .whip:
                        self?.whipLeaders = leaders
                        self?.whipLeadersMain = leaders
                    }
                    self?.group.leave()
                case .failure(let error):
                    print(error)
                    self?.group.leave()
                }
            }
        }
    }
    
    private func setAllLeagueLeaders() {
        let stats = [Stat.hr, Stat.avg, Stat.hits, Stat.rbi, Stat.sb, Stat.wins, Stat.era, Stat.sv, Stat.so, Stat.whip]
        group.enter()
        DispatchQueue.global().async(group: group) {
            var statIndex = 0
            for _ in stats {
                self.getStatLeaders(for: stats[statIndex])
                statIndex += 1
            }
            self.group.leave()
        }
    }
    
    func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        cv.frame = view.bounds
        view.addSubview(cv)
        
        self.collectionView = cv
        collectionView.backgroundColor = .tertiarySystemBackground
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
        segmentedControl.selectedSegmentIndex = 0
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        ])
    }
    
    private func setDefaultStats() {
        self.hrLeaders = self.hrLeadersMain
        self.avgLeaders = self.avgLeadersMain
        self.rbiLeaders = self.rbiLeadersMain
        self.sbLeaders = self.sbLeadersMain
        self.hitLeaders = self.hitLeadersMain
        
        self.winLeaders = self.winLeadersMain
        self.eraLeaders = self.eraLeadersMain
        self.svLeaders = self.svLeadersMain
        self.soLeaders = self.soLeadersMain
    }
    
    @objc func viewDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Displays the original leaders list
            DispatchQueue.main.async {
                self.setDefaultStats()
                self.collectionView.reloadData()
            }
        case 1:
            setLeaders(for: League.al)
        case 2:
            setLeaders(for: League.nl)
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
            self.hitLeaders = self.getLeagueLeaders(leagueLeaders: self.hitLeaders, for: league)
            
            self.winLeaders = self.getLeagueLeaders(leagueLeaders: self.winLeaders, for: league)
            self.eraLeaders = self.getLeagueLeaders(leagueLeaders: self.eraLeaders, for: league)
            self.svLeaders = self.getLeagueLeaders(leagueLeaders: self.svLeaders, for: league)
            self.soLeaders = self.getLeagueLeaders(leagueLeaders: self.soLeaders, for: league)
            self.whipLeaders = self.getLeagueLeaders(leagueLeaders: self.whipLeaders, for: league)
            self.collectionView.reloadData()
        }
        setDefaultStats()
    }
    
    private func getLeagueLeaders(leagueLeaders: [LeagueLeaders], for league: String) -> [LeagueLeaders]{
        var leaders = [LeagueLeaders]()
        for n in 0..<leagueLeaders.count {
            if leagueLeaders[n].league == league {
                leaders.append(leagueLeaders[n])
            }
        }
        return leaders
    }
    
    private func getOffsetIndexAndStatIndex(currentIndex: Int) -> (offsetIndex: Int, statIndex: Int) {
        switch currentIndex {
        case 1...5:
            return (1, 0)
        case 7...11:
            return (7, 1)
        case 13...17:
            return (13, 2)
        case 19...23:
            return (19, 3)
        default:
            return (25, 4)
        }
    }
}


extension LeagueLeadersVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // cellForItemAt located in extension file
    
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
        
        let hittingStats = [hrLeaders, hitLeaders, avgLeaders, sbLeaders, rbiLeaders]
        let pitchingStats = [winLeaders, eraLeaders, soLeaders, svLeaders, whipLeaders]
        
        for n in 1...29 {
            let statIndex = getOffsetIndexAndStatIndex(currentIndex: n).statIndex
            let offsetIndex = getOffsetIndexAndStatIndex(currentIndex: n).offsetIndex
            
            if indexPath.section == 0 {
                vc.statType = .hitting
                vc.isPitcher = false
                
                if indexPath.item == n {
                    vc.playerName = hittingStats[statIndex][n-offsetIndex].name
                    vc.playerID = hittingStats[statIndex][n-offsetIndex].playerID
                    vc.playerTeam = hittingStats[statIndex][n-offsetIndex].teamName
                }
            } else {
                vc.isPitcher = true
                vc.statType = .pitching
                
                if indexPath.item == n {
                    vc.playerName = pitchingStats[statIndex][n-offsetIndex].name
                    vc.playerID = pitchingStats[statIndex][n-offsetIndex].playerID
                    vc.playerTeam = pitchingStats[statIndex][n-offsetIndex].teamName
                }
            }
        }
    }
}
