//
//  KOA1UITests.swift
//  KOA1UITests
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import XCTest

class KOA1UITests: XCTestCase {
    
    var app: XCUIApplication!

        
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testfavoriteButtonChange() {
        let app = XCUIApplication()
        app.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("Pilot")
        sleep(10)
        let movieTableView = app.tables["table--moviesTableView"]
    
        let tableCells = movieTableView.cells
        if tableCells.count > 0 {
            let count: Int = min((tableCells.count - 1), 5)
            
            let promise = expectation(description: "Wait for table cells")
            
            for i in stride(from: 0, to: count , by: 1) {
                
                let tableCell = tableCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                if !tableCell.images["Star"].exists {
                    tableCell.tap()
                    app.buttons["Add to favorite"].tap()
                    XCTAssert(app.buttons["Favorited"].exists)
                    
                    app.buttons["X"].tap()
                    XCTAssert(tableCell.images["Star"].exists)
                }
                if i == (count - 1) {
                    promise.fulfill()
                }
            }
            waitForExpectations(timeout: 20, handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")
            
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
    }
    
    func testEmptyLabels() {
        let tabBars = app.tabBars
        
        tabBars.buttons["Search"].tap()
        let movieTableView = app.tables["table--moviesTableView"]
        if movieTableView.cells.count > 0 {
            XCTAssert(!app.staticTexts["No Results"].exists)
        }
        else {
             XCTAssert(app.staticTexts["No Results"].exists)
        }
        
        
        tabBars.buttons["Favorites"].tap()
        let favoriteTableView = app.tables["table--moviesTableView"]
        if favoriteTableView.cells.count > 0 {
            XCTAssert(!app.staticTexts["No Favorites"].exists)
        }
        else {
            XCTAssert(app.staticTexts["No Favorites"].exists)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCorrectTitle() {
        let tabBars = app.tabBars
        
        XCTAssert(tabBars.buttons["Search"].exists)
        XCTAssert(tabBars.buttons["Favorites"].exists)
        
        tabBars.buttons["Search"].tap()
        XCTAssert(app.navigationBars["iTunes Movies"].exists)
        
        tabBars.buttons["Favorites"].tap()
        XCTAssert(app.navigationBars["Favorites"].exists)
        
    }
    
}
