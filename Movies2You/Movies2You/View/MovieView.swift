//
//  MovieView.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI
import ColorKit

// main view
struct MovieView: View {
    @ObservedObject var movieViewModel = MovieViewModel()
    @State var mainColor = Color.white
    @State var secondaryColor = Color.white
    @State var backgroundColor = Color.white
    
    var body: some View {
        ZStack {
            backButton.zIndex(2)
            ScrollView {
                if let movie = movieViewModel.movie {
                    VStack(spacing: 0) {
                        MovieHeaderImage(movie: movie)
                        MovieHeaderInfo(movieModelView: movieViewModel,
                                        movie: movie,
                                        primaryColor: mainColor,
                                        secondaryColor: secondaryColor,
                                        backgroundColor: backgroundColor)
                        VStack(spacing: 0) {
                            // gets a RelatedMoviesItemView with each related movie's info
                            ForEach (movie.relatedMovies) { relatedMovie in
                                Button {
                                    movieViewModel.getMovie(movieID: relatedMovie.id)
                                    // get main and secondary colors based on the new movie's poster
                                    setColors(urlPath: relatedMovie.posterImageURL)
                                } label : {
                                    RelatedMoviesItemView(movieViewModel: movieViewModel,
                                                          relatedMovie: relatedMovie,
                                                          primaryColor: mainColor,
                                                          secondaryColor: secondaryColor,
                                                          isLastItem: relatedMovie.id == movie.relatedMovies.last?.id)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                        .background(backgroundColor)
                        .onAppear {
                            // get main and secondary colors based on the main image poster
                            setColors(urlPath: movie.posterImageURL)
                        }
                        bottomButtons
                            .padding(.bottom, 30)
                    }
                }
            }
            .zIndex(1)
            .background(backgroundColor)
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
                    .foregroundColor(backgroundColor)
                    .background(mainColor)
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
                            .foregroundColor(backgroundColor)
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(backgroundColor)
                    .background(mainColor)
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
        .foregroundColor(mainColor)
    }
    
    func setColors(urlPath: String) {
        // gets the url based on the path to the image
        let url = URL(string: urlPath)!
        var image: UIImage? = nil

        // Fetch image data
        if let data = try? Data(contentsOf: url) {
            // Create UIImage
            image = UIImage(data: data)!
        }
        
        do {
            // get the dominant colors array
            let dominant = try image!.dominantColors()
            // sets a palette based on the dominant colors
            let palette = ColorPalette(orderedColors: dominant, ignoreContrastRatio: true)
            
            let primary = palette?.primary ?? UIColor.white
            let secondary = palette?.secondary ?? UIColor.white
            let background = palette?.background ?? UIColor.white
            
            mainColor = Color(uiColor: primary)
            // uses the secondary color as background for better contrast
            backgroundColor = Color(uiColor: secondary)
            // uses the background color as secondary for better contrast
            secondaryColor = Color(uiColor: background)
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
