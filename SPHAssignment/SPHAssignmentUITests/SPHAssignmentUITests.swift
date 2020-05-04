//
//  SPHAssignmentUITests.swift
//  SPHAssignmentUITests
//
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import XCTest


class SPHAssignmentUITests: XCTestCase {
    
    
    
    func testViews() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.isDisplayingView)
        let tableView = app.tables
        let cell = tableView.cells.firstMatch
        XCTAssertTrue(cell.exists)
        let image = app.otherElements.containing(.image, identifier: "imageView").firstMatch
        XCTAssertTrue(image.exists)
        image.tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
extension XCUIApplication {
    var isDisplayingView: Bool {
        return otherElements["ViewController"].exists
    }
}


