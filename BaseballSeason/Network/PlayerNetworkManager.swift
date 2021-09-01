//
//  NetworkManager.swift
//  BaseballSeason
//
//  Created by Jon E on 4/1/21.
//

import UIKit

class PlayerNetworkManager {
    static let shared = PlayerNetworkManager()
    private init(){}
    
    var favorites = [FavoritePlayers]()
}
