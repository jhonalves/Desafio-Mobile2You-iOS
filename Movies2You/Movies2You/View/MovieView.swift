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
                        MovieHeaderInfo(movieModelView: movieViewModel, movie: movie)
                        VStack(spacing: 0) {
                            // gets a RelatedMoviesItemView with each related movie's info
                            ForEach (movie.relatedMovies) { relatedMovie in
                                Button {
                                    movieViewModel.getMovie(movieID: relatedMovie.id)
                                } label : {
                                    RelatedMoviesItemView(movieViewModel: movieViewModel,
                                                          relatedMovie: relatedMovie,
                                                          isLastItem: relatedMovie.id == movie.relatedMovies.last?.id)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                        .background(.black)
                        bottomButtons
                            .padding(.bottom, 30)
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
    
    var bottomButtons: some View {
        VStack{
            Button {
                movieViewModel.toggleIsLiked()
            } label: {
                // if the main movie is liked
                if let isLiked = movieViewModel.movie?.isLiked, isLiked == true {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .transition(AnyTransition.scale)
                        Text("Liked")
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(6)
                }
                // else, shows button to like the movie
                else {
                    HStack {
                        Spacer()
                        Image(systemName: "heart")
                            .transition(AnyTransition.scale)
                        Text("Like")
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 10)
            Button {
                if let movie = movieViewModel.movie {
                    for relatedMovie in movie.relatedMovies {
                        movieViewModel.toggleAllToAdded(relatedMovieID: relatedMovie.id)
                    }
                }
            } label: {
                // if all related movies are added shows "Added to My Lists"
                if let allRelatedAdded = movieViewModel.movie?.allRelatedAdded, allRelatedAdded == true {
                    HStack {
                        Spacer()
                        Text("Added to My Lists")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(6)
                }
                // else, shows button to add all related movies
                else {
                    HStack {
                        Spacer()
                        Text("Add to My Lists")
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(lineWidth: 1)
                    )
                }
            }
            .padding(10)
        }
        .foregroundColor(.white)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
