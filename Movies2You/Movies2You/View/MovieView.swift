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
                        RelatedMoviesItemView(movieViewModel: movieViewModel, relatedMovie: relatedMovie)
                    }
                }
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }
}

// creates a view with the main movie backdrop image, title, likes and views numbers
struct MovieHeaderView: View {
    var movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            // gets the image from the movie backdrop URL
            AsyncImage(url: URL(string: movie.backdropImageURL)) { phase in
                Group {
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                    // if there's a error it shows a black view item
                    else if phase.error != nil {
                        Color.black
                    }
                    // shows loading element while the image is downloaded
                    else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(movie.title)
                    .bold()
                    .font(.title)
                Spacer()
                HStack(alignment: .center) {
                    Text(String(movie.likes))
                    Text("Likes")
                    Text(String(movie.views))
                    Text("Views")
                    Spacer()
                }
                .font(.caption)
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

// gets a movie and creates a view with poster image, title, release year and genres
struct RelatedMoviesItemView: View {
    var movieViewModel: MovieViewModel
    var relatedMovie: Movie
    
    var body: some View {
        HStack {
            // gets the image from the movie poster URL
            AsyncImage(url: URL(string: relatedMovie.posterImageURL)) { phase in
                Group {
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Rectangle())
                    }
                    // if there's a error it shows a black view item
                    else if phase.error != nil {
                        Color.black
                    }
                    // shows loading element while the image is downloaded
                    else {
                        ProgressView()
                    }
                }
                .frame(width: 60, height: 100, alignment: .center)
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    Text(relatedMovie.title)
                    HStack {
                        Text(String(relatedMovie.releaseYear))
                        Text(relatedMovie.genres[0].name)
                        Spacer()
                    }
                    .font(.caption)
                    Spacer()
                }
                .padding(.horizontal, 3)
                checkMarks
            }
            .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 6)
    }
    
    // set of check marks that are displayed conforming to each related movie data
    var checkMarks: some View {
        Group {
            if relatedMovie.watched {
                Image(systemName: "checkmark.circle.fill")
                    .onTapGesture {
                        // sets both watched and added to false
                        movieViewModel.toggleWatched(relatedMovieID: relatedMovie.id)
                    }
            } else if relatedMovie.added {
                Image(systemName: "plus.circle.fill")
                    .onTapGesture {
                        // sets added to true
                        movieViewModel.toggleWatched(relatedMovieID: relatedMovie.id)
                    }
            } else {
                Image(systemName: "circle")
                    .onTapGesture {
                        // sets added to true
                        movieViewModel.toggleAdded(relatedMovieID: relatedMovie.id)
                    }
            }
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
