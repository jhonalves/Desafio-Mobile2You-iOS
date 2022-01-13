//
//  MovieAPI.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import Foundation

// set default movie or get movie id
class MovieAPI {
    
    // get the movie data, stores in a Movie model and returns it
    func fetchMovie(movieID: Int, completion: @escaping (Movie?) -> Void ) {
        // pass the movieID to get the formatted URL to make the request
        let url = formatURL(movieID: movieID)
        
        // get the movie data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            // try to decode de movie data into a Movie model
            if let movieData = data, var movie = try? jsonDecoder.decode(Movie.self, from: movieData) {
                // fixing the view count that comes in a /1000 format
                movie.views = movie.views * 1000
                // returns Movie model if success
                completion(movie)
            } else {
                // returns nil if fails
                completion(nil)
            }
        }
        task.resume()
    }
    
    // get the related movie data, stores in a Movie model array and returns it
    func fetchRelatedMovies(movieID: Int, modifier: String, completion: @escaping (RelatedMovies?) -> Void ) {
        // pass the movieID and modifier to get the formatted URL to make the request
        let url = formatURL(movieID: movieID, modifier: modifier)
        
        // get the movie data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            // try to decode de movie data into a RelatedMovies model
            if let relatedMoviesData = data, let relatedMovies = try? jsonDecoder.decode(RelatedMovies.self, from: relatedMoviesData) {
                // returns Array of Movie model if success
                completion(relatedMovies)
            } else {
                // returns nil if fails
                completion(nil)
            }
        }
        task.resume()
    }
    
    // gets movie id and modifier and returns formatted URL
    // modifier will be added after the movie id
    // it must be nil if there's no modifier
    // or "/modifier" if there's one
    func formatURL(movieID: Int, modifier: String? = nil) -> URL {
        // base API request url
        let baseURL = apiConstants.apiBaseURL
        
        // creates the url with movie id
        var movieURL: URL!
        if modifier != nil {
            // add modifier if there's one
            movieURL = URL(string: baseURL + String(movieID) + modifier!)!
        } else {
            movieURL = URL(string: baseURL + String(movieID))!
        }
        
        // queries to be added to the movie url, including the API key
        let queries: [String: String] = [
            // gets a String with de API key
            // the function is in a separeted file in the Helpers folder that's not uploaded with the project
            "api_key": apiConstants.apiKey,
            "language": apiConstants.language
        ]
        
        // final url with the movie id, possible modifier and all the queries
        let url = movieURL.withQuery(queries)!
        
        return url
    }
    
    // gathering API constants
    struct apiConstants {
        static let apiBaseURL = "https://api.themoviedb.org/3/movie/"
        static let apiKey = GetAPIKey()
        static let language = "pt-BR"
    }
}
