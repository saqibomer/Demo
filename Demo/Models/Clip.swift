//
//  Clip.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//


import Foundation
struct Clip : Codable {
	let clip : String?
	let clips : Clips?
	let video : String?
	let preview : String?

	enum CodingKeys: String, CodingKey {

		case clip = "clip"
		case clips = "clips"
		case video = "video"
		case preview = "preview"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		clip = try values.decodeIfPresent(String.self, forKey: .clip)
		clips = try values.decodeIfPresent(Clips.self, forKey: .clips)
		video = try values.decodeIfPresent(String.self, forKey: .video)
		preview = try values.decodeIfPresent(String.self, forKey: .preview)
	}

}
