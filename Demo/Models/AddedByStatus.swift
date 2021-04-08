//
//  AddedByStatus.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct AddedByStatus : Codable {
	let yet : Int?
	let owned : Int?
	let beaten : Int?
	let toplay : Int?
	let dropped : Int?
	let playing : Int?

	enum CodingKeys: String, CodingKey {

		case yet = "yet"
		case owned = "owned"
		case beaten = "beaten"
		case toplay = "toplay"
		case dropped = "dropped"
		case playing = "playing"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		yet = try values.decodeIfPresent(Int.self, forKey: .yet)
		owned = try values.decodeIfPresent(Int.self, forKey: .owned)
		beaten = try values.decodeIfPresent(Int.self, forKey: .beaten)
		toplay = try values.decodeIfPresent(Int.self, forKey: .toplay)
		dropped = try values.decodeIfPresent(Int.self, forKey: .dropped)
		playing = try values.decodeIfPresent(Int.self, forKey: .playing)
	}

}
