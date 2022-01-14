//
//  MovieModel.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import Foundation

struct Movie: Codable, Identifiable {
    private(set) var id: Int
    private(set) var title: String
    private(set) var releaseDate: String
    var releaseYear: Int {
        // get the release year from the release date
        Int(releaseDate.split(separator: "-")[0]) ?? 0
    }
    private(set) var genres: Array<Genre> = []
    private(set) var likes: Double // vote_count
    private(set) var views: Double // popularity
    private(set) var backdropImagePath: String
    var backdropImageURL: String {
        // turn the poster path into the proper image URL
        String("https://image.tmdb.org/t/p/w500" + self.backdropImagePath)
    }
    private(set) var posterImagePath: String
    var posterImageURL: String {
        // turn the backdrop path into the proper image URL
        String("https://image.tmdb.org/t/p/w500" + self.posterImagePath)
    }
    private(set) var relatedMovies: Array<Movie> = []
    
    // properties not related with the JSON income
    private(set) var isLiked = false
    private(set) var isAdded = false
    private(set) var isWatched = false
    // is true when all related movies "isAdded" is true
    var allRelatedAdded: Bool {
        get {
            var allAdded = true
            
            for relatedMovie in relatedMovies {
                // if one of the movies' isAdded is false, then allAdded will be returned as false
                if !relatedMovie.isAdded {
                    allAdded = relatedMovie.isAdded
                }
            }
            return allAdded
        }
    }
    
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
    
    mutating func fixViewCount(numberToUpdate: Double) {
        let updatedNumber = numberToUpdate * 1000
        
        views = updatedNumber
    }
    
    mutating func addRelatedMovie(newRelatedMovie: Movie) {
        relatedMovies.append(newRelatedMovie)
    }
    
    mutating func toggleIsLiked() {
        isLiked.toggle()
    }
    
    // gets a related movie id and set its "isAdded" properties to true
    mutating func toggleIsAdded(relatedMovieID: Int) {
        // gets the related movie index
        if let isAddedMovieIndex = relatedMovies.firstIndex(where: { $0.id == relatedMovieID }) {
            // if not isAdded
            if !relatedMovies[isAddedMovieIndex].isAdded {
                relatedMovies[isAddedMovieIndex].isAdded.toggle()
            } else {
                return
            }
        }
    }
    
    // gets a related movie id and toggles the "isWatched" property
    mutating func toggleIsWatched(relatedMovieID: Int) {
        // gets the related movie index
        if let isWatchedMovieIndex = relatedMovies.firstIndex(where: { $0.id == relatedMovieID }) {
            // if not isWatched
            if !relatedMovies[isWatchedMovieIndex].isWatched {
                relatedMovies[isWatchedMovieIndex].isWatched.toggle()
            // if isWatched
            } else {
                relatedMovies[isWatchedMovieIndex].isWatched.toggle()
                // also sets isAdded to false
                if relatedMovies[isWatchedMovieIndex].isAdded { relatedMovies[isWatchedMovieIndex].isAdded.toggle() }
            }
        }
    }
    
    mutating func toggleAllToAdded(relatedMovieID: Int) {
        // gets the related movie index
        if let isAddedMovieIndex = relatedMovies.firstIndex(where: { $0.id == relatedMovieID }) {
            relatedMovies[isAddedMovieIndex].isAdded = true
        }
    }
}

struct Genre: Codable, Identifiable {
    private(set) var id: Int
    private(set) var name: String
    
    // bind API properties to Genre properties
    enum CodingKeys: String, CodingKey {
            case id
            case name
    }
}

struct RelatedMovies: Codable {
    private(set) var results: Array<RelatedMovie>
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
        private(set) var id: Int
    }
}
