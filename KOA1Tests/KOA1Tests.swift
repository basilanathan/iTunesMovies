//
//  KOA1Tests.swift
//  KOA1Tests
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import XCTest
@testable import KOA1

class KOA1Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovieSearchAPI() {
        let promise = expectation(description: "Movies are downloaded")
        MovieUtility.shared.fetchMoviesFor(searchTerm: "Avengers") { (movies, errorMessage) in
            if let theMovies = movies {
                if theMovies.count > 0 {
                    promise.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Test Timed out. \(String(describing: error?.localizedDescription))")
        }
    }
    
    
    func testCheckMovieDate() {
        let promise = expectation(description: "Dates are correct")
        MovieUtility.shared.fetchMoviesFor(searchTerm: "Ball") { (movies, errorMessage) in
            var datesCorrect = true
            if let theMovies = movies {
                for aMovie in theMovies {
                    if aMovie.releaseDate == nil {
                        datesCorrect = false
                    }
                }
            }
            if datesCorrect {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error, "Test Timed out. \(String(describing: error?.localizedDescription))")
        }
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
    
}
