//
//  RelatedMoviesItemView.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 13/01/22.
//

import SwiftUI

// gets a movie and creates a view with poster image, title, release year and genres
struct RelatedMoviesItemView: View {
    var movieViewModel: MovieViewModel
    var relatedMovie: Movie
    var isLastItem: Bool
    
    var body: some View {
        HStack {
            // gets the image from the movie poster URL
            AsyncImage(url: URL(string: relatedMovie.posterImageURL)) { phase in
                Group {
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipped()
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
            // related movie info
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Spacer()
                        Text(relatedMovie.title)
                        HStack {
                            Text(String(relatedMovie.releaseYear))
                            // shows first two genres
                            if relatedMovie.genres.count == 1 {
                                Text(relatedMovie.genres[0].name)
                            } else if relatedMovie.genres.count > 1 {
                                Text(relatedMovie.genres[0].name + ", " + relatedMovie.genres[1].name)
                            }
                            Spacer()
                        }
                        .font(.caption)
                        Spacer()
                    }
                    .padding(.horizontal, 3)
                    VStack {
                        checkMarks
                            .padding(.top, 10)
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                // if its not the last item on the list adds a divider
                if !isLastItem {
                    Divider().background(.gray).opacity(0.4)
                }
            }
        }
        .padding(.horizontal, 6)
    }
    
    // set of check marks that are displayed conforming to each related movie data
    var checkMarks: some View {
        Group {
            if relatedMovie.watched {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.small)
                    .onTapGesture {
                        // sets both watched and added to false
                        movieViewModel.toggleWatched(relatedMovieID: relatedMovie.id)
                    }
            } else if relatedMovie.added {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.small)
                    .onTapGesture {
                        // sets added to true
                        movieViewModel.toggleWatched(relatedMovieID: relatedMovie.id)
                    }
            } else {
                Image(systemName: "circle")
                    .imageScale(.small)
                    .onTapGesture {
                        // sets added to true
                        movieViewModel.toggleAdded(relatedMovieID: relatedMovie.id)
                    }
            }
        }
        .padding(.trailing, 6)
    }
}
