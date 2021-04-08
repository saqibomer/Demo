//
//  Years.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Years : Codable {
	let from : Int?
	let to : Int?
	let filter : String?
	let decade : Int?
	let years : [Years]?
	let nofollow : Bool?
	let count : Int?

	enum CodingKeys: String, CodingKey {

		case from = "from"
		case to = "to"
		case filter = "filter"
		case decade = "decade"
		case years = "years"
		case nofollow = "nofollow"
		case count = "count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		from = try values.decodeIfPresent(Int.self, forKey: .from)
		to = try values.decodeIfPresent(Int.self, forKey: .to)
		filter = try values.decodeIfPresent(String.self, forKey: .filter)
		decade = try values.decodeIfPresent(Int.self, forKey: .decade)
		years = try values.decodeIfPresent([Years].self, forKey: .years)
		nofollow = try values.decodeIfPresent(Bool.self, forKey: .nofollow)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
	}

}
