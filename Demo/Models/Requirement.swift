//
//  Requirement.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Requirement : Codable {
    
    let minimum : String?
    let recommended : String?

    enum CodingKeys: String, CodingKey {

        case minimum = "minimum"
        case recommended = "recommended"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        minimum = try values.decodeIfPresent(String.self, forKey: .minimum)
        recommended = try values.decodeIfPresent(String.self, forKey: .recommended)
    }

}
