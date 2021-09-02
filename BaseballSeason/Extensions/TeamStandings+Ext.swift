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
        let sortedALEast = alEastStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedALCentral = alCentralStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedALWest = alWestStandings.sorted { $0.winPercentage < $1.winPercentage}
        
        let sortedNLEast = nlEastStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedNLCentral = nlCentralStandings.sorted { $0.winPercentage < $1.winPercentage}
        let sortedNLWest = nlWestStandings.sorted { $0.winPercentage < $1.winPercentage}
        
        if indexPath.item != 0 && indexPath.item % 6 != 0 && indexPath.item % 6 != 5 {
            cell.defaultCorner()
        }
        
        if indexPath.item == 5 || indexPath.item == 11 || indexPath.item == 17 || indexPath.item == 23 {
            cell.setBottomCornerRadius()
        }
        
        let ALTitleCellDictionary: [Int: String] = [0: Division.alEast, 6: Division.alCentral,
                                                    12: Division.alWest, 18: Division.alWildCard]
        let NLTitleCellDictionary: [Int: String] = [0: Division.nlEast, 6: Division.nlCentral,
                                                    12: Division.nlWest, 18: Division.nlWildCard]
        
        let currentIndex = indexPath.item
        let currentALDivision = ALTitleCellDictionary[currentIndex] ?? ""
        let currentNLDivision = NLTitleCellDictionary[currentIndex] ?? ""
        
        // MARK: Creating AL standings cells
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0, 6, 12, 18:
                cell.configureDivisionTitle(division: currentALDivision)
                cell.setTopCornerRadius()
            case 1...5:
                cell.configureMainView(standings: sortedALEast, index: currentIndex-1, isDivisionStanding: true)
            case 7...11:
                cell.configureMainView(standings: sortedALCentral, index: currentIndex-7, isDivisionStanding: true)
            case 13...17:
                cell.configureMainView(standings: sortedALWest, index: currentIndex-13, isDivisionStanding: true)
            case 19...23:
                cell.configureMainView(standings: alWildCardStandings, index: currentIndex-19, isDivisionStanding: false)
            default:
                break
            }
        }
        
        // MARK: Creating NL standings cells
        if indexPath.section == 1 {
            switch indexPath.item {
            case 0, 6, 12, 18:
                cell.configureDivisionTitle(division: currentNLDivision)
                cell.setTopCornerRadius()
            case 1...5:
                cell.configureMainView(standings: sortedNLEast, index: currentIndex-1, isDivisionStanding: true)
            case 7...11:
                cell.configureMainView(standings: sortedNLCentral, index: currentIndex-7, isDivisionStanding: true)
            case 13...17:
                cell.configureMainView(standings: sortedNLWest, index: currentIndex-13, isDivisionStanding: true)
            case 19...23:
                cell.configureMainView(standings: nlWildCardStandings, index: currentIndex-19, isDivisionStanding: false)
            default:
                break
            }
        }
        return cell
    }
}
