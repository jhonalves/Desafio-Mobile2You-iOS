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
        ZStack {
            backButton.zIndex(2)
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
            .zIndex(1)
            .background(.black)
            .ignoresSafeArea()
        }
    }
    
    // back button just for visual purposes
    // no action is executed when pressed
    var backButton: some View {
        HStack {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .opacity(0.7)
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                .padding(.top, 6)
                .padding(.leading, 14)
                Spacer()
            }
            Spacer()
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
