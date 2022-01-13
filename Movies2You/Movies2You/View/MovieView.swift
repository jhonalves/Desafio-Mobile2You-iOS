//
//  MovieView.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI

// main view
struct MovieView: View {
    @ObservedObject var movieViewModel = MovieViewModel()
    
    var body: some View {
        ScrollView {
            if let movie = movieViewModel.movie {
                MovieHeaderView(movie: movie)
            }
            // checks if there's a related movies list
            if let relatedMoviesList = movieViewModel.movie?.relatedMovies {
                VStack {
                    // gets a RelatedMoviesItemView with each movie's info
                    ForEach (relatedMoviesList) { relatedMovie in
                        RelatedMoviesItemView(movieViewModel: movieViewModel,
                                              relatedMovie: relatedMovie,
                                              isLastItem: relatedMovie.id == relatedMoviesList.last?.id)
                    }
                }
                .background(.black)
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
