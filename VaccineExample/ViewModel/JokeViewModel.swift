//
//  JokeViewModel.swift
//  VaccineExample
//
//  Created by Munir Xavier Wanis on 2020-09-21.
//

import UIKit
import Vaccine

protocol JokeViewModeling {
    func getRandomJoke(callback: @escaping (Result<JokeModel, Error>) -> Void)
}

final class JokeViewModel: JokeViewModeling {
    @Inject(ChuckNorrisServicing.self) var service
    
    func getRandomJoke(callback: @escaping (Result<JokeModel, Error>) -> Void) {
        service.getRandomJoke { result in
            switch result {
            case .success(let response):
                callback(.success(JokeModel(response: response)))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
