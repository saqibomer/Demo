//
//  Results.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation
struct Results : Codable {
	let id : Int?
	let slug : String?
	let name : String?
	let released : String?
	let tba : Bool?
	let backgroundImage : String?
	let rating : Double?
	let ratingTop : Int?
	let ratings : [Ratings]?
	let ratingsCount : Int?
	let reviewsTextCount : Int?
	let added : Int?
	let addedByStatus : AddedByStatus?
	let metacritic : Int?
	let playtime : Int?
	let suggestionsCount : Int?
	let updated : String?
	let userGame : String?
	let reviewsCount : Int?
	let saturatedColor : String?
	let dominantColor : String?
	let platforms : [Platforms]?
	let parentPlatforms : [ParentPlatforms]?
	let genres : [Genres]?
	let stores : [Stores]?
	let clip : Clip?
	let tags : [Tags]?
	let esrbRating : EsrbRating?
	let shortScreenshots : [ShortScreenshots]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case slug = "slug"
		case name = "name"
		case released = "released"
		case tba = "tba"
		case backgroundImage = "background_image"
		case rating = "rating"
		case ratingTop = "rating_top"
		case ratings = "ratings"
		case ratingsCount = "ratings_count"
		case reviewsTextCount = "reviews_text_count"
		case added = "added"
		case addedByStatus = "added_by_status"
		case metacritic = "metacritic"
		case playtime = "playtime"
		case suggestionsCount = "suggestions_count"
		case updated = "updated"
		case userGame = "user_game"
		case reviewsCount = "reviews_count"
		case saturatedColor = "saturated_color"
		case dominantColor = "dominant_color"
		case platforms = "platforms"
		case parentPlatforms = "parent_platforms"
		case genres = "genres"
		case stores = "stores"
		case clip = "clip"
		case tags = "tags"
		case esrbRating = "esrb_rating"
		case shortScreenshots = "short_screenshots"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		released = try values.decodeIfPresent(String.self, forKey: .released)
		tba = try values.decodeIfPresent(Bool.self, forKey: .tba)
		backgroundImage = try values.decodeIfPresent(String.self, forKey: .backgroundImage)
		rating = try values.decodeIfPresent(Double.self, forKey: .rating)
		ratingTop = try values.decodeIfPresent(Int.self, forKey: .ratingTop)
		ratings = try values.decodeIfPresent([Ratings].self, forKey: .ratings)
		ratingsCount = try values.decodeIfPresent(Int.self, forKey: .ratingsCount)
		reviewsTextCount = try values.decodeIfPresent(Int.self, forKey: .reviewsTextCount)
		added = try values.decodeIfPresent(Int.self, forKey: .added)
		addedByStatus = try values.decodeIfPresent(AddedByStatus.self, forKey: .addedByStatus)
		metacritic = try values.decodeIfPresent(Int.self, forKey: .metacritic)
		playtime = try values.decodeIfPresent(Int.self, forKey: .playtime)
		suggestionsCount = try values.decodeIfPresent(Int.self, forKey: .suggestionsCount)
		updated = try values.decodeIfPresent(String.self, forKey: .updated)
		userGame = try values.decodeIfPresent(String.self, forKey: .userGame)
		reviewsCount = try values.decodeIfPresent(Int.self, forKey: .reviewsCount)
		saturatedColor = try values.decodeIfPresent(String.self, forKey: .saturatedColor)
		dominantColor = try values.decodeIfPresent(String.self, forKey: .dominantColor)
		platforms = try values.decodeIfPresent([Platforms].self, forKey: .platforms)
		parentPlatforms = try values.decodeIfPresent([ParentPlatforms].self, forKey: .parentPlatforms)
		genres = try values.decodeIfPresent([Genres].self, forKey: .genres)
		stores = try values.decodeIfPresent([Stores].self, forKey: .stores)
		clip = try values.decodeIfPresent(Clip.self, forKey: .clip)
		tags = try values.decodeIfPresent([Tags].self, forKey: .tags)
		esrbRating = try values.decodeIfPresent(EsrbRating.self, forKey: .esrbRating)
		shortScreenshots = try values.decodeIfPresent([ShortScreenshots].self, forKey: .shortScreenshots)
	}

}
