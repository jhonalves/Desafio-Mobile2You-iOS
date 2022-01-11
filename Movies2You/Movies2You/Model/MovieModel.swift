//
//  MovieModel.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var releaseDate: String
    var releaseYear: Int {
        // get the release year from the release date
        Int(releaseDate.split(separator: "-")[0]) ?? 0
    }
    var genrers: Array<Genrer> = []
    var likes: Double // vote_count
    var views: Double // popularity
    var backdropImagePath: String
    var backdropImageURL: String {
        // turn the poster path into the proper image URL
        String("https://image.tmdb.org/t/p/w500" + self.backdropImagePath)
    }
    var posterImagePath: String
    var posterImageURL: String {
        // turn the backdrop path into the proper image URL
        String("https://image.tmdb.org/t/p/w500" + self.backdropImagePath)
    }
    var relatedMovies: Array<Movie> = []
    
    // bind API properties to Movie properties
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case likes = "vote_count"
        case views = "popularity"
        case backdropImagePath = "backdrop_path"
        case posterImagePath = "poster_path"
    }
}

struct Genrer: Codable {
    var id: Int
    var name: String
    
    // bind API properties to Genrer properties
    enum CodingKeys: String, CodingKey {
            case id
            case name
    }
}

struct RelatedMovies: Codable {
    var results: Array<Movie>
    
    // bind API properties to RelatedMovies properties
    enum CodingKeys: String, CodingKey {
        case results
    }
}
