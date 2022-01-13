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
                VStack(spacing: 0) {
                    MovieHeaderImage(movie: movie)
                    MovieHeaderInfo(movie: movie)
                    VStack(spacing: 0) {
                        // gets a RelatedMoviesItemView with each related movie's info
                        ForEach (movie.relatedMovies) { relatedMovie in
                            RelatedMoviesItemView(movieViewModel: movieViewModel,
                                                  relatedMovie: relatedMovie,
                                                  isLastItem: relatedMovie.id == movie.relatedMovies.last?.id)
                        }
                    }
                    .background(.black)
                }
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
