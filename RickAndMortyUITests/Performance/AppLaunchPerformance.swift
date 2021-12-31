//
//  AppLaunchPerformance.swift
//  RickAndMortyUITests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest

class AppLaunchPerformance: XCTestCase {
    private var application: XCUIApplication?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            application?.launch()
        }
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
