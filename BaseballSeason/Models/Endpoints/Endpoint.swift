//
//  Endpoint.swift
//  BaseballSeason
//
//  Created by Jon E on 8/28/21.
//

import Foundation

protocol Endpoint {
    var scheme: String { get}
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
    var headers: [String: String] { get }
}
