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

        // setting the top corner radius of the stat name cell
        func setTopCorner() {
            cell.statView.layer.cornerRadius = 16
            cell.statView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        // setting the bottom corner radius of the last cell in the group
        func setBottomCorner() {
            cell.statView.layer.cornerRadius = 16
            cell.statView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
        }
        
        func defaultCell() {
            cell.statView.layer.cornerRadius = 0
            cell.isUserInteractionEnabled = true
        }
        
        if indexPath.item != 0 && indexPath.item % 6 != 0 && indexPath.item % 6 != 5 {
            defaultCell()
        }
        
        // MARK: Creating hitting leaders cells
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.hrs)
                setTopCorner()
            case 1:
                cell.configureMain(leaders: hrLeaders[0])
            case 2:
                cell.configureMain(leaders: hrLeaders[1])
            case 3:
                cell.configureMain(leaders: hrLeaders[2])
            case 4:
                cell.configureMain(leaders: hrLeaders[3])
            case 5:
                cell.configureMain(leaders: hrLeaders[4])
                setBottomCorner()
            case 6:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.hits)
                setTopCorner()
            case 7:
                cell.configureMain(leaders: hitLeaders[0])
            case 8:
                cell.configureMain(leaders: hitLeaders[1])
            case 9:
                cell.configureMain(leaders: hitLeaders[2])
            case 10:
                cell.configureMain(leaders: hitLeaders[3])
            case 11:
                cell.configureMain(leaders: hitLeaders[4])
                setBottomCorner()
            case 12:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.avg)
                setTopCorner()
            case 13:
                cell.configureMain(leaders: avgLeaders[0])
            case 14:
                cell.configureMain(leaders: avgLeaders[1])
            case 15:
                cell.configureMain(leaders: avgLeaders[2])
            case 16:
                cell.configureMain(leaders: avgLeaders[3])
            case 17:
                cell.configureMain(leaders: avgLeaders[4])
                setBottomCorner()
            case 18:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.sb)
                setTopCorner()
            case 19:
                cell.configureMain(leaders: sbLeaders[0])
            case 20:
                cell.configureMain(leaders: sbLeaders[1])
            case 21:
                cell.configureMain(leaders: sbLeaders[2])
            case 22:
                cell.configureMain(leaders: sbLeaders[3])
            case 23:
                cell.configureMain(leaders: sbLeaders[4])
                setBottomCorner()
            case 24:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.rbi)
                setTopCorner()
            case 25:
                cell.configureMain(leaders: rbiLeaders[0])
            case 26:
                cell.configureMain(leaders: rbiLeaders[1])
            case 27:
                cell.configureMain(leaders: rbiLeaders[2])
            case 28:
                cell.configureMain(leaders: rbiLeaders[3])
            case 29:
                cell.configureMain(leaders: rbiLeaders[4])
                setBottomCorner()
            default:
                break
            }
        }

        // MARK: Creating pitching leaders cells
        if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.wins)
                setTopCorner()
            case 1:
                cell.configureMain(leaders: winLeaders[0])
            case 2:
                cell.configureMain(leaders: winLeaders[1])
            case 3:
                cell.configureMain(leaders: winLeaders[2])
            case 4:
                cell.configureMain(leaders: winLeaders[3])
            case 5:
                cell.configureMain(leaders: winLeaders[4])
                setBottomCorner()
            case 6:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.era)
                setTopCorner()
            case 7:
                cell.configureMain(leaders: eraLeaders[0])
            case 8:
                cell.configureMain(leaders: eraLeaders[1])
            case 9:
                cell.configureMain(leaders: eraLeaders[2])
            case 10:
                cell.configureMain(leaders: eraLeaders[3])
            case 11:
                cell.configureMain(leaders: eraLeaders[4])
                setBottomCorner()
            case 12:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.so)
                setTopCorner()
            case 13:
                cell.configureMain(leaders: soLeaders[0])
            case 14:
                cell.configureMain(leaders: soLeaders[1])
            case 15:
                cell.configureMain(leaders: soLeaders[2])
            case 16:
                cell.configureMain(leaders: soLeaders[3])
            case 17:
                cell.configureMain(leaders: soLeaders[4])
                setBottomCorner()
            case 18:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.saves)
                setTopCorner()
            case 19:
                cell.configureMain(leaders: svLeaders[0])
            case 20:
                cell.configureMain(leaders: svLeaders[1])
            case 21:
                cell.configureMain(leaders: svLeaders[2])
            case 22:
                cell.configureMain(leaders: svLeaders[3])
            case 23:
                cell.configureMain(leaders: svLeaders[4])
                setBottomCorner()
            case 24:
                cell.isUserInteractionEnabled = false
                cell.configureStatName(statName: StatTitle.whip)
                setTopCorner()
            case 25:
                cell.configureMain(leaders: whipLeaders[0])
            case 26:
                cell.configureMain(leaders: whipLeaders[1])
            case 27:
                cell.configureMain(leaders: whipLeaders[2])
            case 28:
                cell.configureMain(leaders: whipLeaders[3])
            case 29:
                cell.configureMain(leaders: whipLeaders[4])
                setBottomCorner()
            default:
                break
            }
        }
        return cell
    }
}
