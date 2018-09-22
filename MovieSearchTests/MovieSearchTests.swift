//
//  MovieSearchTests.swift
//  MovieSearchTests
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import XCTest
@testable import MovieSearch

class MovieSearchTests: XCTestCase {
    
    var viewController: ViewController!
    var store: MoviesDataMocks.MockStore!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        store = MoviesDataMocks.MockStore()
        viewController = ViewController(nibName: nil, bundle: nil)
        _ = viewController.view
        viewController.movies = store.mockedMovies
        viewController.loadViewIfNeeded()
        XCTAssert(viewController != nil, "News View Controller should not be nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testModels() {
        let mockedResponseModel = store.mockedResponseModel
        viewController.viewDidLoad()
        viewController.viewDidAppear(true)
        wait(for: 4)
        /// Putting XCTAssert
        XCTAssert(viewController.movies.count ==  mockedResponseModel.movies.count, "Model count should be same")
        XCTAssert(viewController.movies.first!.title == mockedResponseModel.movies.first!.title, "Data should be same")
    }
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
    
}
