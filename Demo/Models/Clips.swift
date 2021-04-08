//
//  Clips.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Clips : Codable {
	let threeTwenty : String?
	let sixFourty : String?
	let full : String?

	enum CodingKeys: String, CodingKey {

		case threeTwenty = "320"
		case sixFourty = "640"
		case full = "full"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        threeTwenty = try values.decodeIfPresent(String.self, forKey: .threeTwenty)
        sixFourty = try values.decodeIfPresent(String.self, forKey: .sixFourty)
		full = try values.decodeIfPresent(String.self, forKey: .full)
	}

}
