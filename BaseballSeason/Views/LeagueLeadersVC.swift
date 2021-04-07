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
    var hrLeaders = [LeagueLeaders]()
    var avgLeaders = [LeagueLeaders]()
    var sbLeaders = [LeagueLeaders]()
    var rbiLeaders = [LeagueLeaders]()
    
    var soLeaders = [LeagueLeaders]()
    var winLeaders = [LeagueLeaders]()
    var svLeaders = [LeagueLeaders]()
    var eraLeaders = [LeagueLeaders]()
    var whipLeaders = [LeagueLeaders]()
    
    let leaderCell = LeadersCollectionCell()
    var segmentedControl = UISegmentedControl(items: [SegmentView.standings, SegmentView.leaders])
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = 1
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //configureCollectionView()
        //configureSegmentedControl()
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
        collectionView.register(LeadersCollectionCell.self, forCellWithReuseIdentifier: LeadersCollectionCell.reuseID)
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(viewDidChange), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
        ])
    }
    
    @objc func viewDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            dismiss(animated: true)
        case 1:
            print(segmentedControl.selectedSegmentIndex)
        default:
            break
        }
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
                
                NetworkManager.shared.getLeagueLeaders(for: stat, statType: hittingOrPitching) { [weak self] result in
                    switch result {
                    case .success(let data):
                        // data is an array of league leaders
                        switch stat {
                        case .avg:
                            self?.avgLeaders = data
                        case .sb:
                            self?.sbLeaders = data
                        case .hr:
                            self?.hrLeaders = data
                        case .rbi:
                            self?.rbiLeaders = data
                        case .hits:
                            self?.hitsLeaders = data
                        case .era:
                            self?.eraLeaders = data
                        case .wins:
                            self?.winLeaders = data
                        case .saves:
                            self?.svLeaders = data
                        case .so:
                            self?.soLeaders = data
                        case .whip:
                            self?.whipLeaders = data
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
    }
}
