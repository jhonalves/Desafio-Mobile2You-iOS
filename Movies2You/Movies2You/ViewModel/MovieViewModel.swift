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
    func getMovie(movieID: Int = MovieConstants.movieID) {
        self.movieAPI.fetchMovie(movieID: movieID) { (fetchedMovie) in
            DispatchQueue.main.async {
                // checks if the movies has already been added
                if self.movie?.id != fetchedMovie?.id {
                    // saves fetched movie if success or nil if fails
                    self.movie = fetchedMovie
                    // if success, gets related movies
                    self.getRelatedMovies(movieID: movieID, modifier: MovieConstants.relatedMoviesModifier)
                }
            }
        }
    }
    
    // takes related movie id and gets movie data, then appends it to the movie.relatedMovies array
    func addRelatedMovie(movieID: Int) {
        self.movieAPI.fetchMovie(movieID: movieID) { (fetchedRelatedMovie) in
            // if success appends to the movie variable
            DispatchQueue.main.async {
                if let relatedMovie = fetchedRelatedMovie {
                    // checks if the movies has already been added to the relatedMovies list
                    if (self.movie?.relatedMovies.first { $0.id == relatedMovie.id } == nil) {
                        // adds the related movie to the list
                        self.movie?.relatedMovies.append(relatedMovie)
                    }
                }
            }
        }
    }
    
    // gets related movies ids array
    func getRelatedMovies(movieID: Int, modifier: String) {
        self.movieAPI.fetchRelatedMovies(movieID: movieID, modifier: modifier) { (fetchedRelatedMovies) in
            DispatchQueue.main.async {
                if let list = fetchedRelatedMovies?.relatedMoviesIDs {
                    // for each movie id calls the addRelatedMovie function to
                    // append its movie data to the movie.relatedMovies array
                    for id in list {
                        self.addRelatedMovie(movieID: id)
                    }
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
