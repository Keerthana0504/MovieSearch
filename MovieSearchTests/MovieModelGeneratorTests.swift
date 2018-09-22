//
//  MovieModelGeneratorTests.swift
//  MovieSearchTests
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import XCTest
@testable import MovieSearch

class MovieModelGenerationTest: XCTestCase {
    
    var passString = "hello"
    var failureString = "?><>"
    let store: Store = MovieStore()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSuccessModel() {
        store.fetchMovies(searchQuery: passString) { (result) in
            switch(result) {
            case .success(let movies):
                XCTAssertNotNil(movies.movies)
            case .error(_):
                print("error")
            }
        }
    }
    
    func testFailureModel() {
        store.fetchMovies(searchQuery: failureString) { (result) in
            switch(result) {
            case .success(let movies):
                XCTAssertNil(movies.movies)
            case .error(_):
                print("error")
            }
        }
    }
    
}

