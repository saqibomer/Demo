//
//  Ratings.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Ratings : Codable {
	let id : Int?
	let title : String?
	let count : Int?
	let percent : Double?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case count = "count"
		case percent = "percent"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
		percent = try values.decodeIfPresent(Double.self, forKey: .percent)
	}

}
