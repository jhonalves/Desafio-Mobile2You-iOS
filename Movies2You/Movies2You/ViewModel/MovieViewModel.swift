//
//  MovieViewModel.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movie: Movie?
    var movieAPI = MovieAPI()
    
    init() {
        // gets the given movie when initializing tha ViewModel
        getMovie(movieID: MovieConstants.movieID)
    }
    
    // gets a movie from the MovieAPI and stores in the movie variable
    func getMovie(movieID: Int) {
        self.movieAPI.fetchMovie(movieID: movieID) { (fetchedMovie) in
            // saves fetched movie if success or nil if fails
            self.movie = fetchedMovie
            // if success, gets related movies
            if fetchedMovie != nil {
                self.getRelatedMovies(movieID: movieID, modifier: MovieConstants.relatedMoviesModifier)
            }
        }
    }
    
    // takes related movie id and gets movie data, then appends it to the movie.relatedMovies array
    func addRelatedMovie(movieID: Int) {
        self.movieAPI.fetchMovie(movieID: movieID) { (fetchedRelatedMovie) in
            // if success appends to the movie variable
            if let relatedMovie = fetchedRelatedMovie {
                self.movie?.relatedMovies.append(relatedMovie)
            }
        }
    }
    
    // gets related movies ids array
    func getRelatedMovies(movieID: Int, modifier: String) {
        self.movieAPI.fetchRelatedMovies(movieID: movieID, modifier: modifier) { (fetchedRelatedMovies) in
            if let list = fetchedRelatedMovies?.relatedMoviesIDs {
                // for each movie id calls the addRelatedMovie function to
                // append its movie data to the movie.relatedMovies array
                for id in list {
                    self.addRelatedMovie(movieID: id)
                }
            }
        }
    }
    
    // gathering ViewModel constants
    struct MovieConstants {
        // corresponds to the "Inception" movie
        static let movieID = 27205
        // corresponds to the "Get Similar Movies" function in the TMDB API
        static let relatedMoviesModifier = "/similar"
    }
}
