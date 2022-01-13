//
//  MovieModel.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id: Int
    var title: String
    var releaseDate: String
    var releaseYear: Int {
        // get the release year from the release date
        Int(releaseDate.split(separator: "-")[0]) ?? 0
    }
    var genres: Array<Genre> = []
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
        String("https://image.tmdb.org/t/p/w500" + self.posterImagePath)
    }
    var relatedMovies: Array<Movie> = []
    
    // properties not related with the JSON income
    var added = false
    var watched = false
    
    // bind API properties to Movie properties
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case genres
        case likes = "vote_count"
        case views = "popularity"
        case backdropImagePath = "backdrop_path"
        case posterImagePath = "poster_path"
    }
    
    // gets a related movie id and set its "added" properties to true
    mutating func toggleAdded(relatedMovieID: Int) {
        // gets the related movie index
        if let addedMovieIndex = relatedMovies.firstIndex(where: { $0.id == relatedMovieID }) {
            // if not added
            if !relatedMovies[addedMovieIndex].added {
                relatedMovies[addedMovieIndex].added.toggle()
            } else {
                return
            }
        }
    }
    
    // gets a related movie id and toggles the "watched" property
    mutating func toggleWatched(relatedMovieID: Int) {
        // gets the related movie index
        if let watchedMovieIndex = relatedMovies.firstIndex(where: { $0.id == relatedMovieID }) {
            // if not watched
            if !relatedMovies[watchedMovieIndex].watched {
                relatedMovies[watchedMovieIndex].watched.toggle()
            // if watched
            } else {
                relatedMovies[watchedMovieIndex].watched.toggle()
                // also sets added to false
                if relatedMovies[watchedMovieIndex].added { relatedMovies[watchedMovieIndex].added.toggle() }
            }
        }
    }
}

struct Genre: Codable {
    var id: Int
    var name: String
    
    // bind API properties to Genre properties
    enum CodingKeys: String, CodingKey {
            case id
            case name
    }
}

struct RelatedMovies: Codable {
    var results: Array<RelatedMovie>
    // turns the results array into a Int array with all the IDs
    var relatedMoviesIDs: Array<Int> {
        get {
            var relatedMoviesIDs: Array<Int> = []
            for relatedMovie in results {
                relatedMoviesIDs.append(relatedMovie.id)
            }
            return relatedMoviesIDs
        }
    }
    
    // bind API properties to RelatedMovies properties
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    // struct to store the "results" field data of the JSON
    struct RelatedMovie: Codable, Identifiable {
        var id: Int
    }
}
