//
//  GamesResponse.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct GamesResponse : Codable {
	let count : Int?
	let next : String?
	let previous : String?
	let results : [Results]?
	let seoTitle : String?
	let seoDescription : String?
	let seoKeywords : String?
	let seoH1 : String?
	let noindex : Bool?
	let nofollow : Bool?
	let description : String?
	let filters : Filters?
	let nofollowCollections : [String]?

	enum CodingKeys: String, CodingKey {

		case count = "count"
		case next = "next"
		case previous = "previous"
		case results = "results"
		case seoTitle = "seo_title"
		case seoDescription = "seo_description"
		case seoKeywords = "seo_keywords"
		case seoH1 = "seo_h1"
		case noindex = "noindex"
		case nofollow = "nofollow"
		case description = "description"
		case filters = "filters"
		case nofollowCollections = "nofollow_collections"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
		next = try values.decodeIfPresent(String.self, forKey: .next)
		previous = try values.decodeIfPresent(String.self, forKey: .previous)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
		seoTitle = try values.decodeIfPresent(String.self, forKey: .seoTitle)
		seoDescription = try values.decodeIfPresent(String.self, forKey: .seoDescription)
        seoKeywords = try values.decodeIfPresent(String.self, forKey: .seoKeywords)
		seoH1 = try values.decodeIfPresent(String.self, forKey: .seoH1)
		noindex = try values.decodeIfPresent(Bool.self, forKey: .noindex)
		nofollow = try values.decodeIfPresent(Bool.self, forKey: .nofollow)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		filters = try values.decodeIfPresent(Filters.self, forKey: .filters)
		nofollowCollections = try values.decodeIfPresent([String].self, forKey: .nofollowCollections)
	}

}
