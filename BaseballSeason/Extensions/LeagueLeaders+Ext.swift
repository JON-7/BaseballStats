//
//  LeagueLeaders+Ext.swift
//  BaseballSeason
//
//  Created by Jon E on 4/5/21.
//

import UIKit

extension LeagueLeadersVC {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeadersCollectionCell.reuseID, for: indexPath) as! LeadersCollectionCell
        
        if indexPath.item != 0 && indexPath.item % 6 != 0 && indexPath.item % 6 != 5 {
            cell.defaultCell()
        }
        
        if indexPath.item == 5 || indexPath.item == 11 || indexPath.item == 17 || indexPath.item == 23 || indexPath.item == 29 {
            cell.setBottomCornerRadius()
        }
        
        let hittingTitleCellDictionary: [Int: String] = [0: StatTitle.hrs, 6: StatTitle.hits, 12: StatTitle.avg, 18: StatTitle.sb, 24: StatTitle.rbi]
        let pitchingTitleCellDictionary: [Int: String] = [0: StatTitle.wins, 6: StatTitle.era, 12: StatTitle.so, 18: StatTitle.saves, 24: StatTitle.whip]
        
        let currentIndex = indexPath.item
        let currentHittingStat = hittingTitleCellDictionary[currentIndex]
        let currentPitchingStat = pitchingTitleCellDictionary[currentIndex]
        
        // MARK: Creating hitting leaders cells
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0, 6, 12, 18, 24:
                cell.configureStatName(statName: currentHittingStat ?? "")
                cell.setTopCornerRadius()
            case 1...5:
                cell.configureMain(leaders: hrLeaders[currentIndex-1])
            case 7...11:
                cell.configureMain(leaders: hitLeaders[currentIndex-7])
            case 13...17:
                cell.configureMain(leaders: avgLeaders[currentIndex-13])
            case 19...23:
                cell.configureMain(leaders: sbLeaders[currentIndex-19])
            case 25...29:
                cell.configureMain(leaders: rbiLeaders[currentIndex-25])
            default:
                break
            }
        }
        
        // MARK: Creating pitching leaders cells
        if indexPath.section == 1 {
            switch indexPath.item {
            case 0, 6, 12, 18, 24:
                cell.configureStatName(statName: currentPitchingStat ?? "")
                cell.setTopCornerRadius()
            case 1...5:
                cell.configureMain(leaders: winLeaders[currentIndex-1])
            case 7...11:
                cell.configureMain(leaders: eraLeaders[currentIndex-7])
            case 13...17:
                cell.configureMain(leaders: soLeaders[currentIndex-13])
            case 19...23:
                cell.configureMain(leaders: svLeaders[currentIndex-19])
            case 25...29:
                cell.configureMain(leaders: whipLeaders[currentIndex-25])
            default:
                break
            }
        }
        return cell
    }
}
