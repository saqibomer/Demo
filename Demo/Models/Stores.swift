//
//  Stores.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Stores : Codable {
	let id : Int?
	let store : Store?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case store = "store"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		store = try values.decodeIfPresent(Store.self, forKey: .store)
	}

}
