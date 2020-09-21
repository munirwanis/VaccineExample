//
//  Model.swift
//  VaccineExample
//
//  Created by Munir Xavier Wanis on 2020-09-21.
//

import Foundation

struct JokeModel {
    let joke: String
    
    init(response: ChuckNorrisResponse) {
        self.joke = response.value
    }
}
