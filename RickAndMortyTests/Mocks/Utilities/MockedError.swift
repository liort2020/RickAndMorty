//
//  MockedError.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

enum MockedError: Swift.Error {
    case valueNeedToBeSet
}
