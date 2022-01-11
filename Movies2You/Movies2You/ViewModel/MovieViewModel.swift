//
//  MovieViewModel.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI

class MovieViewModel {
    var movie: Movie?
    
    init() {
        getMovie()
    }
    
    func getMovie() {
        MovieAPI.fetchMovie { (fetchedInfo) in
            print(fetchedInfo ?? "fails")
        }
        
    }
}
