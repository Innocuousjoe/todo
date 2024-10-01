//
//  todoCoreDataTests.swift
//  todoTests
//
//  Created by Nick Coelius on 10/1/24.
//

import XCTest

final class todoCoreDataTests: XCTestCase {
    func testBasicCoreData() throws {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        MockListItems().createObject(
            with: (userId: 3, id: 2, title: "One", completed: false),
            in: context
        )
        MockListItems().createObject(
            with: (userId: 4, id: 5, title: "Six", completed: true),
            in: context
        )
        MockListItems().createObject(
            with: (userId: 7, id: 8, title: "Nine", completed: false),
            in: context
        )
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        
        try! context.save()
        waitForExpectations(timeout: 2.0) { error in
            print("Error in waiting for expectations: \(String(describing: error))")
        }
    }
}
