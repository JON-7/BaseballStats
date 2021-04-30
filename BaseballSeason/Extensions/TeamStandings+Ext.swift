//
//  TeamStandings+Ext.swift
//  BaseballSeason
//
//  Created by Jon E on 4/5/21.
//

import UIKit

extension TeamStandingsVC {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandingsCollectionCell.reuseID, for: indexPath) as! StandingsCollectionCell

        //MARK: Sorting each division by winning percentage
        let sortedAlEast = alEastStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedALCentral = alCentralStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedALWest = alWestStandings.sorted { $0.winPercentage < $1.winPercentage}

        let sortedNLEast = nlEastStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedNLCentral = nlCentralStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedNLWest = nlWestStandings.sorted { $0.winPercentage < $1.winPercentage}

        // setting the top corner radius of the stat name cell
        func setTopCorner() {
            cell.teamView.layer.cornerRadius = 16
            cell.teamView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        // setting the bottom corner radius of the last cell in the group
        func setBottomCorner() {
            cell.teamView.layer.cornerRadius = 16
            cell.teamView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
        }

        func defaultCorner() {
            cell.teamView.layer.cornerRadius = 0
        }

        // MARK: Creating AL standings cells
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                cell.isUserInteractionEnabled = false
                cell.configureDivisionTitle(division: Division.alEast)
                setTopCorner()
            case 1:
                cell.configureMainView(standings: sortedAlEast, index: 0)
                defaultCorner()
            case 2:
                cell.configureMainView(standings: sortedAlEast, index: 1)
                defaultCorner()
            case 3:
                cell.configureMainView(standings: sortedAlEast, index: 2)
                defaultCorner()
            case 4:
                cell.configureMainView(standings: sortedAlEast, index: 3)
                defaultCorner()
            case 5:
                cell.configureMainView(standings: sortedAlEast, index: 4)
                setBottomCorner()
            case 6:
                cell.isUserInteractionEnabled = false
                cell.configureDivisionTitle(division: Division.alCentral)
                setTopCorner()
            case 7:
                cell.configureMainView(standings: sortedALCentral, index: 0)
                defaultCorner()
            case 8:
                cell.configureMainView(standings: sortedALCentral, index: 1)
                defaultCorner()
            case 9:
                cell.configureMainView(standings: sortedALCentral, index: 2)
                defaultCorner()
            case 10:
                cell.configureMainView(standings: sortedALCentral, index: 3)
                defaultCorner()
            case 11:
                cell.configureMainView(standings: sortedALCentral, index: 4)
                setBottomCorner()
            case 12:
                cell.isUserInteractionEnabled = false
                cell.configureDivisionTitle(division: Division.alWest)
                setTopCorner()
            case 13:
                cell.configureMainView(standings: sortedALWest, index: 0)
                defaultCorner()
            case 14:
                cell.configureMainView(standings: sortedALWest, index: 1)
                defaultCorner()
            case 15:
                cell.configureMainView(standings: sortedALWest, index: 2)
                defaultCorner()
            case 16:
                cell.configureMainView(standings: sortedALWest, index: 3)
                defaultCorner()
            case 17:
                cell.configureMainView(standings: sortedALWest, index: 4)
                setBottomCorner()
            default:
                break
            }
        }
        
        // MARK: Creating NL standings cells
        if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                cell.isUserInteractionEnabled = false
                cell.configureDivisionTitle(division: Division.nlEast)
                setTopCorner()
            case 1:
                cell.configureMainView(standings: sortedNLEast, index: 0)
                defaultCorner()
            case 2:
                cell.configureMainView(standings: sortedNLEast, index: 1)
                defaultCorner()
            case 3:
                cell.configureMainView(standings: sortedNLEast, index: 2)
                defaultCorner()
            case 4:
                cell.configureMainView(standings: sortedNLEast, index: 3)
                defaultCorner()
            case 5:
                cell.configureMainView(standings: sortedNLEast, index: 4)
                setBottomCorner()
            case 6:
                cell.isUserInteractionEnabled = false
                cell.configureDivisionTitle(division: Division.nlCentral)
                setTopCorner()
            case 7:
                cell.configureMainView(standings: sortedNLCentral, index: 0)
                defaultCorner()
            case 8:
                cell.configureMainView(standings: sortedNLCentral, index: 1)
                defaultCorner()
            case 9:
                cell.configureMainView(standings: sortedNLCentral, index: 2)
                defaultCorner()
            case 10:
                cell.configureMainView(standings: sortedNLCentral, index: 3)
                defaultCorner()
            case 11:
                cell.configureMainView(standings: sortedNLCentral, index: 4)
                setBottomCorner()
            case 12:
                cell.isUserInteractionEnabled = false
                cell.configureDivisionTitle(division: Division.nlWest)
                setTopCorner()
            case 13:
                cell.configureMainView(standings: sortedNLWest, index: 0)
                defaultCorner()
            case 14:
                cell.configureMainView(standings: sortedNLWest, index: 1)
                defaultCorner()
            case 15:
                cell.configureMainView(standings: sortedNLWest, index: 2)
                defaultCorner()
            case 16:
                cell.configureMainView(standings: sortedNLWest, index: 3)
                defaultCorner()
            case 17:
                cell.configureMainView(standings: sortedNLWest, index: 4)
                setBottomCorner()
            default:
                break
            }
        }
        return cell
    }
}
