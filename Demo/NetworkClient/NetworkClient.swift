//
//  NetworkClient.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation

protocol NetworkingService {
    @discardableResult func fetchGames(withQuery query: String, completion: @escaping (GamesResponse?) -> ()) -> URLSessionDataTask
}

final class NetworkClient: NetworkingService {
    private let session   = URLSession.shared
    private let baseURl   = Environment.baseURL.absoluteString
    private let endpoints = NetworkConstants.Endpoints.self
    
    @discardableResult
    func fetchGames(withQuery query: String, completion: @escaping (GamesResponse?) -> ()) -> URLSessionDataTask {
        let urlString = baseURl+endpoints.games+"\(query)"
        let request = URLRequest(url: URL(string: urlString)!)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                    let response = try? JSONDecoder().decode(GamesResponse.self, from: data) else {
                        completion(nil)
                        return
                }
                completion(response)
            }
        }
        task.resume()
        return task
    }
}
