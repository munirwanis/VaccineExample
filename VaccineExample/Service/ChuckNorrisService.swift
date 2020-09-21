//
//  ChuckNorrisService.swift
//  VaccineExample
//
//  Created by Munir Xavier Wanis on 2020-09-21.
//

import UIKit

protocol ChuckNorrisServicing {
    func getRandomJoke(callback: @escaping (Result<ChuckNorrisResponse, Error>) -> Void)
}

final class ChuckNorrisService: ChuckNorrisServicing {
    func getRandomJoke(callback: @escaping (Result<ChuckNorrisResponse, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "https://api.chucknorris.io/jokes/random")!) { (data, _, error) in
            if let error = error {
                return callback(.failure(error))
            }
            
            guard let data = data else {
                return callback(.failure(URLError(.unknown)))
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let model = try decoder.decode(ChuckNorrisResponse.self, from: data)
                callback(.success(model))
            } catch {
                callback(.failure(error))
            }
        }.resume()
    }
}
