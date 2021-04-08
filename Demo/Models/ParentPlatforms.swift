//
//  ParentPlatforms.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct ParentPlatforms : Codable {
	let platform : Platform?

	enum CodingKeys: String, CodingKey {

		case platform = "platform"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		platform = try values.decodeIfPresent(Platform.self, forKey: .platform)
	}

}
