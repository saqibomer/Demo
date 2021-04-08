//
//  Genres.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Genres : Codable {
	let id : Int?
	let name : String?
	let slug : String?
	let gamesCount : Int?
	let imageBackground : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case slug = "slug"
		case gamesCount = "games_count"
		case imageBackground = "image_background"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
        gamesCount = try values.decodeIfPresent(Int.self, forKey: .gamesCount)
        imageBackground = try values.decodeIfPresent(String.self, forKey: .imageBackground)
	}

}
