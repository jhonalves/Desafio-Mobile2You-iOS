//
//  Movies2YouApp.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI

@main
struct Movies2YouApp: App {
    private let movie = MovieViewModel()
    
    var body: some Scene {
        WindowGroup {
            MovieView(movie: movie)
        }
    }
}
