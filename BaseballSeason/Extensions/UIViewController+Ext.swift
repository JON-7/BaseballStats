//
//  UIViewController+Ext.swift
//  BaseballSeason
//
//  Created by Jon E on 4/2/21.
//

import UIKit

var loadingView: UIView?

extension UIViewController {
    
    // shown when waiting for network calls to complete
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
        DispatchQueue.main.async {
            loadingView?.removeFromSuperview()
        }
    }
    
    // collectionView layout for standings and league leaders
    func configureCollectionLayout() -> UICollectionViewCompositionalLayout {
        let itemHeight = (view.bounds.height * 0.44) / 7
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(itemHeight)))
            
            // vertical group
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1)), subitems: [item])
            
            // horizontal group
            let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.44)), subitems: [nestedGroup])
            
            let section = NSCollectionLayoutSection(group: outerGroup)
            section.contentInsets.bottom = 15
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            if sectionNumber == 0 {
                section.contentInsets.top = 90
            }
            return section
        }
        return layout
    }
    
    func displayErrorMessage(error: ErrorMessage) {
        let ac = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: .none)
        ac.addAction(okBtn)
        present(ac, animated: true)
    }
}
