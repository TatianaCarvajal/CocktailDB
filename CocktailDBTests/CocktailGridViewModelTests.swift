//
//  CocktailGridViewModelTests.swift
//  CocktailDBTests
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import XCTest
@testable import CocktailDB

final class CocktailGridViewModelTests: XCTestCase {

    func testFetchCocktailCategories() async {
            let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
            
            await cocktailGridViewModel.fetchCocktailCategories()
            
            switch cocktailGridViewModel.state {
            case let .loadedCategories(categories):
                XCTAssertEqual(categories, .init(drinks: [.init(category: "Ordinary Drink")]))
            default: XCTFail("This shouldn't happen because the mock has a default success")
            }
        }
}
