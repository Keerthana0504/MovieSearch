//
//  MovieDataMocks.swift
//  MovieSearchTests
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import Foundation
@testable import MovieSearch

enum MoviesDataMocks {
    class MockStore: Store {
        func fetchMovies(searchQuery: String, result: @escaping ((Result<MovieDetailsModel>) -> Void)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                result(.success(self.mockedResponseModel))
            }
            
        }
        
        func fetchMore(result: @escaping ((Result<MovieDetailsModel>) -> Void)) {
            
        }
        
        var mockedResponseModel: MovieDetailsModel {
            return MovieDetailsModel(movies: mockedMovies)
        }
        
        var mockedMovies: [Movies] {
            let mockMovie1 = Movies(title: "Movie1",
                                    poster_path: nil,
                                    overview: "Overview of Movie1",
                                    release_date: nil)
            
            let mockMovie2 = Movies(title: "Movie2",
                                    poster_path: nil,
                                    overview: "Overview of Movie2",
                                    release_date: nil)
            return [mockMovie1, mockMovie2]
        }
    }
}
