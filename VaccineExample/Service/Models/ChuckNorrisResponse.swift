//
//  ChuckNorrisResponse.swift
//  VaccineExample
//
//  Created by Munir Xavier Wanis on 2020-09-21.
//

import Foundation

struct ChuckNorrisResponse: Decodable {
    let iconUrl: String
    let id: String
    let url: String
    let value: String
}
