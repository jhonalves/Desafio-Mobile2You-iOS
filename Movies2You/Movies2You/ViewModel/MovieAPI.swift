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
    static func fetchMovie(completion: @escaping (Movie?) -> Void ) {
        // base API request url
        let baseURL = "https://api.themoviedb.org/3/movie/"
        // url with movie id
        let movieURL = URL(string: baseURL + "27205")!
        // queries to be added to the movie url, including the API key
        let queries: [String: String] = [
            "api_key": GetAPIKey(),
            "language": "pt-BR"
        ]
        // final url with the movie id and all the queries
        let url = movieURL.withQuery(queries)!
        
        // get the movie data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            // try to decode de movie data into a Movie model
            if let movieData = data, let movie = try? jsonDecoder.decode(Movie.self, from: movieData) {
                // returns Movie model if success
                completion(movie)
            } else {
                // returns nil if fails
                completion(nil)
            }
        }
        task.resume()
    }
}
