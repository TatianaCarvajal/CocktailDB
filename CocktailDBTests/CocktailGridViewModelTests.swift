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
    
    func testFetchCocktailCategoriesFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.withSuccess = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.fetchCocktailCategories()
        
        switch cocktailGridViewModel.state {
        case let .error(error):
            XCTAssertEqual(error, .noDataFound)
        default: XCTFail("This shouldn't happen because the mock should always fail")
        }
    }
    
    func testFetchDrinksByName() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.fetchCocktailByName(name: "Margarita")
        
        switch cocktailGridViewModel.state {
        case let .loadedCocktails(drinks):
            XCTAssertEqual(drinks, .init(drinks: [Drinks(id: "1502", name: "Margarita", category: "Ordinary Drink", instruction: "Shake and strain into a chilled cocktail glass.")]))
        default: XCTFail("This shouldn't happen because the mock has a default success")
        }
    }
}
