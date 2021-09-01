//
//  NetworkLayer.swift
//  BaseballSeason
//
//  Created by Jon E on 8/28/21.
//

import UIKit

class NetworkLayer {
    class func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, ErrorMessage>) -> ()) {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                do {
                    let responseObject = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(responseObject as! T))
                } catch {
                    completion(.failure(.noResponce))
                }
            }
        }.resume()
    }
}
