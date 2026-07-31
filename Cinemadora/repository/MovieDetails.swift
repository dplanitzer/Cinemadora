//
//  MovieDetails.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/30/26.
//

import Foundation

nonisolated struct MovieDetails : Decodable, Identifiable, Equatable, Hashable {
    
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: CollectionSummary?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String
    let originCountry: [String]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [CompanySummary]
    let productionCountries: [Country]
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [Language]
    let status: String?
    let tagline: String?
    let title: String
    let isVideo: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys : String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case isVideo = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

nonisolated struct CollectionSummary : Decodable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let name: String
    let posterPath: String
    let backdropPath: String?

    enum CodingKeys : String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

nonisolated struct CompanySummary : Decodable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys : String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

nonisolated struct Country : Decodable, Identifiable, Equatable, Hashable {
    
    let id: String          // ISO 3166 country code
    let name: String

    enum CodingKeys : String, CodingKey {
        case id = "iso_3166_1"
        case name
    }
}

nonisolated struct Language : Decodable, Identifiable, Equatable, Hashable {
    
    let id: String          // ISO 3166 country code
    let name: String
    let englishName: String

    enum CodingKeys : String, CodingKey {
        case id = "iso_639_1"
        case name
        case englishName = "english_name"
    }
}
