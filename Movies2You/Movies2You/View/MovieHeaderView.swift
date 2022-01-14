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
    // variable to toggle the heart icon in the interface
    @State var isLiked: Bool = false
    // heartOpacity to help the flying heart animation
    @State var heartOpacity: Double = 0
    
    @Namespace private var heartNamespace
    
    var body: some View {
        HStack {
            // main movie's info
            VStack(alignment: .leading) {
                Text(movie.title)
                    .fontWeight(.heavy)
                    .bold()
                    .font(.title)
                Spacer()
                HStack(alignment: .center) {
                    HStack(spacing: 0) {
                        ZStack {
                            Image(systemName: "heart.fill")
                            // secondary like icon to help the flying heart animation
                            if isLiked {
                                Image(systemName: "heart.fill")
                                    .transition(AnyTransition.identity)
                                    .matchedGeometryEffect(id: 1, in: heartNamespace)
                            }
                        }
                        Text(" ")
                        if movie.likes > 1000 {
                            // if the number is over 1000, formats it to show in 'thousands K' format
                            Text(String(format: "%.1fK Likes", movie.likes / 1000)
                                .replacingOccurrences(of: ".0", with: ""))  // if number ends in .0, removes the dot
                        } else {
                            Text(String(format: "%.0f Likes", movie.likes))
                        }
                    }
                    .padding(.trailing, 16)
                    HStack(spacing: 0) {
                        Image(systemName: "eye")
                        Text(" ")
                        if movie.views > 1000 {
                            // if the number is over 1000, formats it to show in 'thousands K' format
                            Text(String(format: "%.1fK Views", movie.views / 1000)
                                .replacingOccurrences(of: ".0", with: ""))  // if number ends in .0, removes the dot
                        } else {
                            Text(String(format: "%.0f Views", movie.views))
                        }
                    }
                    Spacer()
                }
                .font(.caption)
            }
            Spacer()
            VStack {
                // like button just for visual purposes, doesn't reflects on the model
                ZStack {
                    if !isLiked {
                        // shows empty heart if not liked
                        Image(systemName: "heart").imageScale(.large)
                            .transition(AnyTransition.scale)
                    } else {
                            // shows filled heart if liked
                            Image(systemName: "heart.fill").imageScale(.large)
                                .transition(AnyTransition.scale)
                    }
                    // secondary liked icon to help the flying heart animation
                    Image(systemName: "heart.fill").imageScale(.large)
                        .transition(AnyTransition.identity)
                        .opacity(heartOpacity)
                        .matchedGeometryEffect(id: 1, in: heartNamespace)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isLiked.toggle()
                    }
                }
                Spacer()
            }
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
