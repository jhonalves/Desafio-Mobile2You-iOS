//
//  MovieView.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI

struct MovieView: View {
    var movie: MovieViewModel
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = MovieViewModel()
        
        MovieView(movie: movie)
    }
}
