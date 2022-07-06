//
//  HeroModel.swift
//  JSONDataStudy
//
//  Created by Ömer Faruk Kılıçaslan on 6.07.2022.
//

import Foundation

struct HeroModel: Decodable {
    
    let localized_name: String
    let primary_attr: String
    let attack_type: String
    let img: String
    let legs: Int
}
