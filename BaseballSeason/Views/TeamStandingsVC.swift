//
//  TeamStandingsVC.swift
//  BaseballSeason
//
//  Created by Jon E on 3/30/21.
//

import UIKit

class TeamStandingsVC: UIViewController {
    
    var alEastStanding = [DivisionStanding]()
    var alCentralStanding = [DivisionStanding]()
    var alWestStanding = [DivisionStanding]()
    
    var nlEastStanding = [DivisionStanding]()
    var nlCentralStanding = [DivisionStanding]()
    var nlWestStanding = [DivisionStanding]()
    
    var segmentedControl = UISegmentedControl(items: [SegmentView.standings, SegmentView.leaders])
    let leagueLeadersVC = LeagueLeadersVC()
    
    weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
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
                            self?.alEastStanding = data
                        case Division.alCentral:
                            self?.alCentralStanding = data
                        case Division.alWest:
                            self?.alWestStanding = data
                        case Division.nlEast:
                            self?.nlEastStanding = data
                        case Division.nlCentral:
                            self?.nlCentralStanding = data
                        case Division.nlWest:
                            self?.nlWestStanding = data
                        default:
                            break
                        }
                    case .failure(let error):
                        print(error)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.configureCollectionView()
            //self.configureSegmentedControl()
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
        case 0:
            print(segmentedControl.selectedSegmentIndex)
            
        case 1:
            print(segmentedControl.selectedSegmentIndex)
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
}

extension TeamStandingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6 cells in each vertical group and there are 3 horizontal groups
        18
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // AL and NL sections
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TeamInfoVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 1:
                vc.teamName = alEastStanding[0].name
                vc.teamID = alEastStanding[0].teamID
            case 2:
                vc.teamName = alEastStanding[1].name
                vc.teamID = alEastStanding[1].teamID
            case 3:
                vc.teamName = alEastStanding[2].name
                vc.teamID = alEastStanding[2].teamID
            case 4:
                vc.teamName = alEastStanding[3].name
                vc.teamID = alEastStanding[3].teamID
            case 5:
                vc.teamName = alEastStanding[4].name
                vc.teamID = alEastStanding[4].teamID
            case 7:
                vc.teamName = alCentralStanding[0].name
                vc.teamID = alCentralStanding[0].teamID
            case 8:
                vc.teamName = alCentralStanding[1].name
                vc.teamID = alCentralStanding[1].teamID
            case 9:
                vc.teamName = alCentralStanding[2].name
                vc.teamID = alCentralStanding[2].teamID
            case 10:
                vc.teamName = alCentralStanding[3].name
                vc.teamID = alCentralStanding[3].teamID
            case 11:
                vc.teamName = alCentralStanding[4].name
                vc.teamID = alCentralStanding[4].teamID
            case 13:
                vc.teamName = alWestStanding[0].name
                vc.teamID = alWestStanding[0].teamID
            case 14:
                vc.teamName = alWestStanding[1].name
                vc.teamID = alWestStanding[1].teamID
            case 15:
                vc.teamName = alWestStanding[2].name
                vc.teamID = alWestStanding[2].teamID
            case 16:
                vc.teamName = alWestStanding[3].name
                vc.teamID = alWestStanding[3].teamID
            case 17:
                vc.teamName = alWestStanding[4].name
                vc.teamID = alWestStanding[4].teamID
            default:
                break
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.item {
            case 1:
                vc.teamName = nlEastStanding[0].name
                vc.teamID = nlEastStanding[0].teamID
            case 2:
                vc.teamName = nlEastStanding[1].name
                vc.teamID = nlEastStanding[1].teamID
            case 3:
                vc.teamName = nlEastStanding[2].name
                vc.teamID = nlEastStanding[2].teamID
            case 4:
                vc.teamName = nlEastStanding[3].name
                vc.teamID = nlEastStanding[3].teamID
            case 5:
                vc.teamName = nlEastStanding[4].name
                vc.teamID = nlEastStanding[4].teamID
            case 7:
                vc.teamName = nlCentralStanding[0].name
                vc.teamID = nlCentralStanding[0].teamID
            case 8:
                vc.teamName = nlCentralStanding[1].name
                vc.teamID = nlCentralStanding[1].teamID
            case 9:
                vc.teamName = nlCentralStanding[2].name
                vc.teamID = nlCentralStanding[2].teamID
            case 10:
                vc.teamName = nlCentralStanding[3].name
                vc.teamID = nlCentralStanding[3].teamID
            case 11:
                vc.teamName = nlCentralStanding[4].name
                vc.teamID = nlCentralStanding[4].teamID
            case 13:
                vc.teamName = nlWestStanding[0].name
                vc.teamID = nlWestStanding[0].teamID
            case 14:
                vc.teamName = nlWestStanding[1].name
                vc.teamID = nlWestStanding[1].teamID
            case 15:
                vc.teamName = nlWestStanding[2].name
                vc.teamID = nlWestStanding[2].teamID
            case 16:
                vc.teamName = nlWestStanding[3].name
                vc.teamID = nlWestStanding[3].teamID
            case 17:
                vc.teamName = nlWestStanding[4].name
                vc.teamID = nlWestStanding[4].teamID
            default:
                break
            }
        }
    }
}
