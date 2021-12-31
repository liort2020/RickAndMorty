//
//  DIContainerPerformanceTests+Inject.swift
//  RickAndMortyPerformanceTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
@testable import RickAndMorty

final class InjectDIContainerPerformanceTests: XCTestCase {
    private var diContainer: DIContainer?
    
    override func setUp() {
        super.setUp()
        diContainer = DIContainer.boot()
    }
    
    func test_inject_container_to_view_performance() throws {
        let diContainer = try XCTUnwrap(diContainer)
        
        measure {
            let _ = EmptyView()
                .inject(diContainer)
        }
    }
    
    override func tearDown() {
        diContainer = nil
        super.tearDown()
    }
}
