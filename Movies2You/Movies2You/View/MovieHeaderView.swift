//
//  MovieHeaderView.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 13/01/22.
//

import SwiftUI

// creates a view with the main movie poster image
struct MovieHeaderImage: View {
    var movie: Movie
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // gets the image from the movie poster URL
                AsyncImage(url: URL(string: movie.posterImageURL)) { phase in
                    Group {
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: geometry.size.width,
                                       height: StretchyHeaderData.imageHeight(geometry))
                                .offset(x: 0, y: StretchyHeaderData.imageOffset(geometry))
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
                }
            }
        }
        // sets the backdrop height to 50% of the screen height
        .frame(height: UIScreen.main.bounds.height * 0.5)
    }
}

// creates a view with the main movie title, likes and views numbers
struct MovieHeaderInfo: View {
    var movie: Movie
    
    var body: some View {
        // main movie's info
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
        .background(.black)
        // shade over the main movie's image
        .overlay(alignment: .top) {
            LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .clear, location: 1),
            ]), startPoint: .bottom, endPoint: .top)
            .frame(height: 100)
            .offset(x: 0, y: -100)
        }
    }
}

struct StretchyHeaderData {
    static func imageOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        
        // when scrolling down
        if offset > 0 {
            // image displacement when stretching the image
            return -offset
        }
        // when scrolling up
        else {
            // creates the smooth effect in the image when scrolling up
            return 0.3 * -offset
        }
    }
    
    static func imageHeight(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        var imageHeight = geometry.size.height
        
        // when scrolling down
        if offset > 0 {
            // adds how much the screen was scrolled to the image height
            imageHeight = imageHeight + offset
        }
        
        return imageHeight
    }
}
