//
//  PrefectureListResponse.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/12.
//

import Foundation

struct PrefectureListResponse: Codable {
    let itemList: [Prefecture]
}

struct Prefecture: Codable {
    let date: String
    let name: String
    let npatients: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case name = "name_jp"
        case npatients
    }
}
