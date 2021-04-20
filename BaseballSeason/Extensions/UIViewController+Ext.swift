//
//  UIViewController+Ext.swift
//  BaseballSeason
//
//  Created by Jon E on 4/2/21.
//

import UIKit

var loadingView: UIView?

extension UIViewController {
    
    func showSpinner() {
        loadingView = UIView(frame: self.view.bounds)
        loadingView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView()
        ai.center = loadingView!.center
        ai.style = .large
        ai.startAnimating()
        loadingView?.addSubview(ai)
        self.view.addSubview(loadingView!)
    }
    
    func removeSpinner() {
        loadingView?.removeFromSuperview()
    }
    
    func configureCollectionLayout() -> UICollectionViewCompositionalLayout {
        let itemHeight = (view.bounds.height * 0.44) / 7
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(itemHeight)))
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1)), subitems: [item])
            
            let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.44)), subitems: [nestedGroup])
            
            let section = NSCollectionLayoutSection(group: outerGroup)
            section.contentInsets.bottom = 15
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            if sectionNumber == 0 {
                section.contentInsets.top = 90
            } else {
                //section.contentInsets.top = 5
            }
            return section
        }
        return layout
    }
}
