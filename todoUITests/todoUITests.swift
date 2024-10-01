//
//  todoUITests.swift
//  todoUITests
//
//  Created by Nick Coelius on 9/27/24.
//

import XCTest
import UITestSugar

final class todoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUI() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Active"].exists)
        XCTAssertTrue(app.staticTexts["Completed"].exists)
        XCTAssertTrue(app.staticTexts["All"].exists)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAddingTask() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.firstMatch.scrollTo { element in
            return element.staticTexts["Add task"].exists
        }
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add task"]/*[[".cells.staticTexts[\"Add task\"]",".staticTexts[\"Add task\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let textField = app.alerts["New Task"].textFields.firstMatch
        textField.tap()
        textField.typeText("Hello, this is a new task")
        app.alerts["New Task"].scrollViews.otherElements.buttons["Save"].tap()
        XCTAssertTrue(app.buttons["Hello, this is a new task"].exists)
    }
    
    func testEditingTask() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionView = app.collectionViews.firstMatch
        let firstCell = collectionView.cells.firstMatch
        firstCell.tap()
        let textField = app.alerts["Edit Task"].textFields.firstMatch
        textField.clearAndEnterText(text: "Eyyyyy")
        app.alerts["Edit Task"].scrollViews.otherElements.buttons["Save"].tap()
        XCTAssertTrue(app.buttons["Eyyyyy"].exists)
    }
    
    func testDeletingTask() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionView = app.collectionViews.firstMatch
        let firstCell = collectionView.cells.firstMatch
        
        firstCell.tap()
        let textField = app.alerts["Edit Task"].textFields.firstMatch
        textField.clearAndEnterText(text: "Eyyyyy")
        app.alerts["Edit Task"].scrollViews.otherElements.buttons["Save"].tap()
        
        firstCell.swipeLeft(velocity: .fast)
        app.buttons["Delete"].tap()
        XCTAssert(!app.buttons["Eyyyyy"].exists)
    }
    
    func testCompletingTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        let collectionView = app.collectionViews.firstMatch
        let firstCell = collectionView.cells.firstMatch
        
        app.staticTexts["Completed"].tap()
        XCTAssertFalse(app.buttons["Eyyyyy"].exists)
        
        app.staticTexts["Active"].tap()
        firstCell.tap()
        let textField = app.alerts["Edit Task"].textFields.firstMatch
        textField.clearAndEnterText(text: "Eyyyyy")
        app.alerts["Edit Task"].scrollViews.otherElements.buttons["Save"].tap()
        
        app.collectionViews.cells.otherElements.containing(.button, identifier:"Eyyyyy").buttons["selected"].tap()
        app.staticTexts["Completed"].tap()
        XCTAssert(app.buttons["Eyyyyy"].exists)
    }
}
