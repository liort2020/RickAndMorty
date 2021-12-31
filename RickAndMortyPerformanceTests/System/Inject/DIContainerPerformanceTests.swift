//
//  DIContainerPerformanceTests.swift
//  RickAndMortyPerformanceTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

final class DIContainerPerformanceTests: XCTestCase {
    func test_boot_performance() {
        measure {
            let _ = DIContainer.boot()
        }
    }
}
