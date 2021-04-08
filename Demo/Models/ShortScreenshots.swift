//
//  ShortScreenshots.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct ShortScreenshots : Codable {
	let id : Int?
	let image : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case image = "image"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		image = try values.decodeIfPresent(String.self, forKey: .image)
	}

}
