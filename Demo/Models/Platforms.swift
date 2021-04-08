//
//  Platforms.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Platforms : Codable {
	let platform : Platform?
	let releasedAt : String?
	let requirementsEn : Requirement?
	let requirementsRu : Requirement?

	enum CodingKeys: String, CodingKey {

		case platform = "platform"
		case releasedAt = "released_at"
		case requirementsEn = "requirements_en"
		case requirementsRu = "requirements_ru"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		platform = try values.decodeIfPresent(Platform.self, forKey: .platform)
        releasedAt = try values.decodeIfPresent(String.self, forKey: .releasedAt)
        requirementsEn = try values.decodeIfPresent(Requirement.self, forKey: .requirementsEn)
        requirementsRu = try values.decodeIfPresent(Requirement.self, forKey: .requirementsRu)
	}

}
