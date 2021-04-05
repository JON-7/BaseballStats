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
    
    var segmentedControl = UISegmentedControl(items: ["Standings", "Leaders"])
    let leagueLeadersVC = LeagueLeadersVC()
    
    weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureCollectionView()
        //configureSegmentedControl()
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
                NetworkManager.shared.getStandings(for: division) { [weak self] result in
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
            self.configureSegmentedControl()
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
            present(leagueLeadersVC, animated: true)
        default:
            break
        }
    }
    
    func configureCollectionView() {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        cv.frame = view.bounds
        view.addSubview(cv)
        
        collectionView = cv
        collectionView.backgroundColor = .lightGray
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
        
    }
}
